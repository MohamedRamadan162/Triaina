require 'rails_helper'

RSpec.describe CourseChatChannel, type: :channel do
  let!(:chat_channel) { create(:chat_channel) }
  let!(:user) { create(:user) }

  before do
    stub_connection current_user: user
  end

  it 'successfully subscribes to stream' do
    subscribe(channel_id: chat_channel.id)

    expect(subscription).to be_confirmed
    expect(subscription).to have_stream_for(chat_channel)
  end

  it 'rejects subscription if user unauthorized' do
  end

  it 'broadcasts message on send_message' do
    subscribe(channel_id: chat_channel.id)
    perform :send_message, message: "Hello"

    expect {
      perform :send_message, message: "Hello"
    }.to have_broadcasted_to(chat_channel).with(hash_including(:message))
  end
end
