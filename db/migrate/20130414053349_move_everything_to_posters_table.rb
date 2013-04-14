class MoveEverythingToPostersTable < ActiveRecord::Migration
  def up
    ActiveRecord::Base.connection.execute('INSERT INTO posters (id, name,
    created_at, updated_at, email, encrypted_password,
    reset_password_token, reset_password_sent_at, remember_created_at,
    sign_in_count, current_sign_in_at, last_sign_in_at, current_sign_in_ip,
    last_sign_in_ip, debug_user) SELECT id, name, created_at, updated_at, email, encrypted_password,
    reset_password_token, reset_password_sent_at, remember_created_at,
    sign_in_count, current_sign_in_at, last_sign_in_at, current_sign_in_ip,
    last_sign_in_ip, debug_user FROM users')

    drop_table :users

    if ActiveRecord::Base.connection.adapter_name == 'PostgreSQL'
      max_id = ActiveRecord::Base.connection.execute("SELECT max(id) as max_id FROM posters").first["max_id"]
      ActiveRecord::Base.connection.execute("ALTER SEQUENCE posters_id_seq RESTART WITH #{max_id}");
    end

    Feed.find_by_sql("SELECT *,title as name FROM feeds").each do |f|
      new = Feed.new(
        :name => f.name,
        :url => f.url,
      )
      new.save
      f.subscriptions.update_all(:feed_id => new.id)
      Post.where(:posted_by_id => f.id, :posted_by_type => 'Feed').update_all(:posted_by_id => new.id, :posted_by_type => 'NewFeed')
    end
    Post.where(:posted_by_type => 'NewFeed').update_all(:posted_by_type => 'Feed')

    drop_table :feeds

    remove_column :posters, :posted_by_type
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
