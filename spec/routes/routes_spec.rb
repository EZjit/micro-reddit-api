# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :controller do
  it { should route(:get, '/api/v1/users').to(action: :index) }
  it { should route(:get, '/api/v1/users/test_user').to(action: :show, _username: 'test_user') }
  it { should route(:post, '/api/v1/users').to(action: :create) }
  it { should route(:put, '/api/v1/users/test_user').to(action: :update, _username: 'test_user') }
  it { should route(:delete, '/api/v1/users/test_user').to(action: :destroy, _username: 'test_user') }
end

RSpec.describe Api::V1::AuthenticationController, type: :controller do
  it { should route(:post, '/api/v1/auth/login').to(action: :login) }
end

RSpec.describe Api::V1::CommunitiesController, type: :controller do
  it { should route(:get, '/api/v1/communities').to(action: :index) }
  it { should route(:get, '/api/v1/communities/some_community').to(action: :show, _name: 'some_community') }
  it { should route(:post, '/api/v1/communities').to(action: :create) }
  it { should route(:put, '/api/v1/communities/some_community').to(action: :update, _name: 'some_community') }
  it { should route(:delete, '/api/v1/communities/some_community').to(action: :destroy, _name: 'some_community') }
end

RSpec.describe Api::V1::PostsController, type: :controller do
  it {
    should route(:get, '/api/v1/communities/some_community/posts').to(action: :index,
                                                                      community__name: 'some_community')
  }
  it {
    should route(:get, '/api/v1/communities/some_community/posts/1').to(action: :show,
                                                                        community__name: 'some_community', id: 1)
  }
  it {
    should route(:post, '/api/v1/communities/some_community/posts').to(action: :create,
                                                                       community__name: 'some_community')
  }
  it {
    should route(:put, '/api/v1/communities/some_community/posts/1').to(action: :update,
                                                                        community__name: 'some_community', id: 1)
  }
  it {
    should route(:delete, '/api/v1/communities/some_community/posts/1').to(action: :destroy,
                                                                           community__name: 'some_community', id: 1)
  }
end

RSpec.describe Api::V1::CommentsController, type: :controller do
  it {
    should route(:get, '/api/v1/communities/some_community/posts/1/comments').to(action: :index,
                                                                                 community__name: 'some_community',
                                                                                 post_id: 1)
  }
  it {
    should route(:get, '/api/v1/communities/some_community/posts/1/comments/1').to(action: :show,
                                                                                   community__name: 'some_community',
                                                                                   post_id: 1,
                                                                                   id: 1)
  }
  it {
    should route(:post, '/api/v1/communities/some_community/posts/1/comments').to(action: :create,
                                                                                  community__name: 'some_community',
                                                                                  post_id: 1)
  }
  it {
    should route(:put, '/api/v1/communities/some_community/posts/1/comments/1').to(action: :update,
                                                                                   community__name: 'some_community',
                                                                                   post_id: 1,
                                                                                   id: 1)
  }
  it {
    should route(:delete, '/api/v1/communities/some_community/posts/1/comments/1').to(action: :destroy,
                                                                                      community__name: 'some_community',
                                                                                      post_id: 1,
                                                                                      id: 1)
  }
end
