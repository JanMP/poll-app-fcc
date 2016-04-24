require "/imports/sortable/template.jade"

if Meteor.isServer
  Sortable = {}
  Sortable.collections = []


if Meteor.isClient

  Sortable = require "/imports/sortable/Sortable.js"

  setEventData = (event) ->
    event.data = Blaze.getData event.item

  
  Template.sortable.onCreated ->

    @options = @data.options ? {}
    for key, value of @data
      unless key is "options" or key is "items"
        @options[key] = value
        delete @data[key]
    @options.sortField = @options.sortField ? "order"
    if @data.items and @data.items.collection
      @collectionName = @data.items.collection.name
      @collection = @data.items.collection
      #this didn't work with local collections:
      #@collection = Mongo.Collection.get @collectionName
    else if @data.items
      # collection passed via items=; does NOT have a .name property, but _name
      @collection = @data.items
      @collectionName = @collection._name
    else if @data.collection
      # cursor passed directly
      @collectionName = @data.collection.name
      @collection = Mongo.Collection.get @collectionName
    else
      # collection passed directly
      @collection = @data
      @collectionName = @collection._name
    delete @data.options


  Template.sortable.onRendered ->

    orderObj = (i) =>
      obj = {}
      obj[@options.sortField] = i
      obj

    reorder = =>
      if @options.sort
        orderArray = @sortable.toArray()
        for id, i in orderArray
          @collection.update id,
            $set : orderObj i

    optionsOnUpdate = @options.onUpdate
    @options.onUpdate = (event) =>
      setEventData event
      if optionsOnUpdate then optionsOnUpdate event, this
      unless event.doNotReorder
        reorder()

    optionsOnAdd = @options.onAdd
    @options.onAdd = (event) =>
      setEventData event
      if optionsOnAdd then optionsOnAdd event, this
      unless event.doNotReorder
        reorder()

    optionsOnRemove = @options.onRemove
    @options.onRemove = (event) =>
      setEventData event
      if optionsOnRemove then optionsOnRemove event, this
      unless event.doNotReorder
        reorder()

    for eventHandler in ["onStart", "onEnd", "onSort", "onFilter"]
      if @options[eventHandler]
        userEventHandler = @options[eventHandler]
        @options[eventHandler] = (event) =>
          setEventData event
          userEventHandler event, this

    @sortable = Sortable.create @find(".sortable-dropzone"),
      this.options
      