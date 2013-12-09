App.ListNotesView = Ember.View.extend({
  templateName:    'app/templates/notes/list',
  notesBinding: 'App.notesController',

  refreshListing: function() {
    App.notesController.findAll();
  }
});