require 'rails_helper'

RSpec.describe ChatMessage, type: :model do
  describe "associations" do
    it { should belong_to(:user).class_name("User").with_foreign_key("user_id") }
    it { should belong_to(:chat_channel).class_name("ChatChannel").with_foreign_key("chat_channel_id") }
  end

  describe "validations" do
    subject { build(:chat_message) }  # ensure valid subject for uniqueness and presence tests

    it { should validate_presence_of(:content) }
    it { should validate_presence_of(:user_id) }
    it { should validate_presence_of(:chat_channel_id) }
  end

  describe "scopes" do
    let!(:users) { create_list(:user, 3) }
    let!(:chat_channels) { create_list(:chat_channel, 3) }

    let!(:chat_message_1) { create(:chat_message, chat_channel: chat_channels[0], user: users[0]) }
    let!(:chat_message_2) { create(:chat_message, chat_channel: chat_channels[1], user: users[0]) }
    let!(:chat_message_3) { create(:chat_message, chat_channel: chat_channels[0], user: users[1]) }

    it "filters by chat_channel_id" do
      expect(ChatMessage.filter_by_chat_channel_id(chat_channels[0].id)).to include(chat_message_1, chat_message_3)
      expect(ChatMessage.filter_by_chat_channel_id(chat_channels[1].id)).to include(chat_message_2)
      expect(ChatMessage.filter_by_chat_channel_id(chat_channels[2].id)).to be_empty
    end

    it "filters by user_id" do
      expect(ChatMessage.filter_by_user_id(users[0].id)).to include(chat_message_1, chat_message_2)
      expect(ChatMessage.filter_by_user_id(users[1].id)).to include(chat_message_3)
      expect(ChatMessage.filter_by_user_id(users[2].id)).to be_empty
    end
  end
end
