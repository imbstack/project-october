describe UsersController do
  before do
    request.env["devise.mapping"] = Devise.mappings[:user]
  end

  describe 'create action' do
    context 'with valid form data' do
      let(:user) { FactoryGirl.build(:user) }
      let(:valid_form_data) do
        {
          :user => {
            :email => user.email,
            :name => user.name,
            :password => user.password,
            :password_confirmation => user.password
          }
        }
      end

      it 'creates the user' do
        post :create, valid_form_data

        User.where(:name => user.name).should be_present
      end
    end

    context 'when the user has omitted a username' do
      let(:user) { FactoryGirl.build(:user) }
      let(:valid_form_data) do
        {
          :user => {
            :email => user.email,
            :password => user.password,
            :password_confirmation => user.password
          }
        }
      end

      it 'does not create the user' do
        post :create, valid_form_data

        User.where(:name => user.name).should be_empty
      end

      it 'redirects you to the signup page' do
        post :create, valid_form_data

        response.should redirect_to new_user_registration_path
      end
    end
  end
end
