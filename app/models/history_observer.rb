class HistoryObserver < ActiveRecord::Observer
  observe :contact, :website, :phone, :address, :email, :note

  def before_update(record)
    History.record(record, :update)
  end
  
  def after_create(record)
    History.record(record, :create)
  end
  
  def after_destroy(record)
    History.record(record, :delete)
  end
end
