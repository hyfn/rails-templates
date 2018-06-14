module RequestHelpers
  extend ActiveSupport::Concern

  def sign_in_user(user = nil)
    user ||= Fabricate(:user)
    if defined? sign_in
      sign_in user
    else
      post user_session_path user: {
        email: user.email,
        password: user.password,
      }
    end
  end

  def log_out
    delete destroy_user_session_path
  end

  # def register_user(user = nil)
  #   user ||= Fabricate.build(:user)
  #   post user_registration_path, params: { user: {
  #     email: user.email,
  #     password: user.password,
  #     password_confirmation: user.password,
  #     first_name: user.first_name,
  #     last_name: user.last_name,
  #     zip_code: user.zip_code,
  #     dob: user.dob,
  #     terms_and_conditions: 1,
  #     captcha: true,
  #   } }
  # end

  # for controller/request specs
  def parsed_body
    JSON.parse(response.body)
  end
end
