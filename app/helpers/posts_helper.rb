module PostsHelper
  def recursify_array_of_comments(comments, parent_id = nil)
    # Takes an array of comments and returns a hash that looks like:
    # [
    #   {
    #   :root => #<Comment 1>
    #   :children => [
    #     {
    #       :root => #<Comment 2>,
    #       :children => [...]
    #     }, ...
    #   ]},
    #   {
    #     :root => #<Comment 3>,
    #   ...and so forth...
    roots = comments.find_all { |c| c.parent_id == parent_id }
    roots.map { |c| { :root => c, :children => recursify_array_of_comments(comments, c.id) } }
  end
end
