require "/imports/sortable/template.jade"

if Meteor.isServer
  Sortable = {}
  Sortable.collections = []


if Meteor.isClient

  Sortable = require "/imports/sortable/Sortable.js"

  setEventData = (event) ->
    event.data = Blaze.getData event.item

  
  Template.sortable.onCreated ->

    this.options = this.data.options ? {}
    for key, value of this.data
      unless key is "options" or key is "items"
        this.options[key] = value
        delete this.data[key]
    this.options.sortField = this.options.sortField ? "order"
    if this.data.items and this.data.items.collection
      this.collectionName = this.data.items.collection.name
      this.collection = Mongo.Collection.get this.collectionName
    else
      console.log "pass Cursor via items= and make sure it has a .name property"
    delete this.data.options


  Template.sortable.onRendered ->

    orderObj = (i) =>
      obj = {}
      obj[this.options.sortField] = i
      obj

    reorder = =>
      if this.options.sort
        orderArray = this.sortable.toArray()
        for id, i in orderArray
          this.collection.update id,
            $set : orderObj i

    optionsOnUpdate = this.options.onUpdate
    this.options.onUpdate = (event) =>
      setEventData event
      if optionsOnUpdate then optionsOnUpdate event, this
      unless event.doNotReorder
        reorder()

    optionsOnAdd = this.options.onAdd
    this.options.onAdd = (event) =>
      setEventData event
      if optionsOnAdd then optionsOnAdd event, this
      unless event.doNotReorder
        reorder()

    optionsOnRemove = this.options.onRemove
    this.options.onRemove = (event) =>
      setEventData event
      if optionsOnRemove then optionsOnRemove event, this
      unless event.doNotReorder
        reorder()

    for eventHandler in ["onStart", "onEnd", "onSort", "onFilter"]
      if this.options[eventHandler]
        userEventHandler = this.options[eventHandler]
        this.options[eventHandler] = (event) =>
          setEventData event
          userEventHandler event, this

    this.sortable = Sortable.create this.find(".sortable-dropzone"),
      this.options
      