import { Meteor } from 'meteor/meteor';
import '/imports/api/surveys.coffee';
import '/imports/api/users.coffee';
import '/imports/api/voted.coffee';
import '/imports/api/publications.coffee';
import '/imports/api/methods.coffee';

Meteor.startup(() => {
  // code to run on server at startup
});
