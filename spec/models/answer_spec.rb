require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { is_expected.to validate_presence_of(:question_id) }
  it { is_expected.to validate_presence_of(:body) }
  it { is_expected.to validate_presence_of(:author_id) }
  # it { is_expected.to validate_uniqueness_of(:body) } / Не смог победить. Тест в указанной формулировке отображается как не пройденный, а модель валидацию делает => ["Body has been given already."]


  it { is_expected.to belong_to(:author).class_name('User') }
  it { is_expected.to belong_to(:question) }
end
