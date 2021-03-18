require 'rails_helper'

RSpec.describe User, type: :model do
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  it { should have_many(:authored_questions).class_name('Question') }
  it { should have_many(:authored_answers).class_name('Answer') }
end
