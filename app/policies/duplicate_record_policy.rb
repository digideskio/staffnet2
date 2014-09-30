class DuplicateRecordPolicy < Struct.new(:user, :record)

  def new_batch?
    user.role? :admin
  end
end