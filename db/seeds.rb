# frozen_string_literal: true

if Rails.env.development?
  User.delete_all
  Community.delete_all
end

# Create admin user
User.create({ name: 'Chad', username: 'superuser', email: 'test@gmail.com',
              password: '0oK9Ij*uh', password_confirmation: '0oK9Ij*uh', is_admin: true })

def create_users
  users = []
  (1..10).each do |i|
    users << { username: "user#{i}", email: "test#{i}@gmail.com",
      password: '0oK9Ij*uh', password_confirmation: '0oK9Ij*uh' }
  end
  User.create(users)
end

def create_communities
  communities = []
  (1..5).each do |i|
    communities << {
      name: "Community number #{i}",
      description: "Community number #{i} description"
    }
  end
  Community.create(communities)
end

def create_posts
  communities = Community.all
  users = User.all
  posts = []
  (1..50).each do |i|
    posts << { title: "Post number #{i}", body: "Some describable body of post number #{i}",
               user: users.sample, community: communities.sample }
  end
  Post.create(posts)
end

def create_top_level_comments
  posts = Post.all
  users = User.all
  comments = []
  (1..500).each do |i|
    comments << { body: "Comment number #{i} on level 0 (top-level)",
                  user: users.sample, post: posts.sample }
  end
  Comment.create(comments)
end

def create_nested_comments
  posts = Post.all
  users = User.all
  comments = []
  (1..50).each do |i|
    parents = Comment.all
    (1..100).each do |j|
      comment = Comment.new({ user: users.sample, post: posts.sample, parent: parents.sample })
      level = get_level(comment)
      comment[:body] = "Comment number #{i * j} on level #{level}"
      comments << comment
    end
  end
  comments.each { |comment| comment.save }
end

def get_level(comment)
  level = 0
  while comment.parent
    level += 1
    comment = comment.parent
  end
  level
end


create_users
create_communities
create_posts
create_top_level_comments
create_nested_comments
