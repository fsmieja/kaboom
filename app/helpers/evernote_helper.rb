module EvernoteHelper
  
  def evernote_auth_token
    session[:evernote_access_token].token if session[:evernote_access_token]
  end
  
  def evernote_client
    @evernote_client ||= EvernoteOAuth::Client.new(token: evernote_auth_token, consumer_key: APP_CONFIG[:evernote_consumer_key], 
                        consumer_secret: APP_CONFIG[:evernote_consumer_secret], sandbox: APP_CONFIG[:evernote_sandbox])
  end
  
  def evernote_user_store
    @evernote_user_store ||= evernote_client.user_store
  end

  def evernote_note_store
    @evernote_note_store ||= evernote_client.note_store
  end
  
  
  def evernote_user
    evernote_user_store.getUser(evernote_auth_token)
  end
  
  def evernote_notes
    filter = Evernote::EDAM::NoteStore::NoteFilter.new
    #filter.setOrder(Evernote::EDAM::NoteStore::NoteSortOrder.UPDATED.getValue());
    spec = Evernote::EDAM::NoteStore::NotesMetadataResultSpec.new;
    #spec.setIncludeTitle(true);
 
    evernote_note_store.findNotesMetadata(evernote_auth_token, filter, 0, 20, spec)
  end
  
  def evernote_note(guid)
    evernote_note_store.getNote(evernote_auth_token, guid, true,
                   false, false, false)
  end

  def evernote_notebooks
    @evernote_notebooks ||= evernote_note_store.listNotebooks(evernote_auth_token)
  end
  
  def evernote_total_note_count
    filter = Evernote::EDAM::NoteStore::NoteFilter.new
    counts = evernote_note_store.findNoteCounts(evernote_auth_token, filter, false)
    evernote_notebooks.inject(0) do |total_count, notebook|
      total_count + (counts.notebookCounts[notebook.guid] || 0)
    end
  end
end