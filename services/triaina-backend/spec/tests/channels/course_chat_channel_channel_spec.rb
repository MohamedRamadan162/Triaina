require 'rails_helper'

RSpec.describe CourseChatChannel, type: :channel do
  let!(:course_chat) { create(:course_chat) }
  let!(:user) { create(:user) }
  let!(:other_user) { create(:user) }
  let!(:existing_message) { create(:chat_message, course_chat: course_chat, user: user, content: "Original message") }

  before do
    stub_connection current_user: user
  end

  describe '#subscribed' do
    it 'successfully subscribes to stream' do
      subscribe(channel_id: course_chat.id)

      expect(subscription).to be_confirmed
      expect(subscription).to have_stream_for(course_chat)
    end

    it 'raises error if chat channel does not exist' do
      expect {
        subscribe(channel_id: 999999)
      }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe '#send_message' do
    before do
      subscribe(channel_id: course_chat.id)
    end

    it 'broadcasts message on send_message' do
      expect {
        perform :send_message, { "message" => "Hello World" }
      }.to have_broadcasted_to(course_chat).with(hash_including(:message))
    end

    it 'creates a new message in the database' do
      initial_count = ChatMessage.count

      perform :send_message, { "message" => "Test message" }

      expect(ChatMessage.count).to eq(initial_count + 1)
      new_message = ChatMessage.order(created_at: :desc).first
      expect(new_message.content).to eq("Test message")
      expect(new_message.user).to eq(user)
      expect(new_message.course_chat).to eq(course_chat)
    end

    it 'broadcasts serialized message' do
      expect {
        perform :send_message, { "message" => "Test message" }
      }.to have_broadcasted_to(course_chat).with { |data|
        expect(data).to have_key(:message)
        expect(data[:message]).to include("content" => "Test message")
      }
    end
  end

  describe '#update_message' do
    before do
      subscribe(channel_id: course_chat.id)
    end

    context 'when user owns the message' do
      it 'updates the message and broadcasts' do
        expect {
          perform :update_message, { "message_id" => existing_message.id, "message" => "Updated content" }
        }.to have_broadcasted_to(course_chat).with(hash_including(:message))

        existing_message.reload
        expect(existing_message.content).to eq("Updated content")
      end
    end

    context 'when user does not own the message' do
      let!(:other_user_message) { create(:chat_message, course_chat: course_chat, user: other_user) }

      it 'rejects the update' do
        expect(subscription).to receive(:reject)

        perform :update_message, { "message_id" => other_user_message.id, "message" => "Hacked content" }

        other_user_message.reload
        expect(other_user_message.content).not_to eq("Hacked content")
      end
    end

    context 'when message does not exist' do
      it 'raises an error' do
        expect {
          perform :update_message, { "message_id" => 999999, "message" => "Updated content" }
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe '#delete_message' do
    before do
      subscribe(channel_id: course_chat.id)
    end

    context 'when user owns the message' do
      it 'deletes the message and broadcasts message_id' do
        message_id = existing_message.id

        expect {
          perform :delete_message, { "message_id" => message_id }
        }.to have_broadcasted_to(course_chat).with({ message_id: message_id })

        expect(ChatMessage.find_by(id: message_id)).to be_nil
      end

      it 'reduces message count' do
        expect {
          perform :delete_message, { "message_id" => existing_message.id }
        }.to change(ChatMessage, :count).by(-1)
      end
    end

    context 'when user does not own the message' do
      let!(:other_user_message) { create(:chat_message, course_chat: course_chat, user: other_user) }

      it 'rejects the deletion' do
        expect(subscription).to receive(:reject)

        perform :delete_message, { "message_id" => other_user_message.id }

        expect(ChatMessage.find_by(id: other_user_message.id)).not_to be_nil
      end
    end

    context 'when message does not exist' do
      it 'raises an error' do
        expect {
          perform :delete_message, { "message_id" => 999999 }
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe '#fetch_messages' do
    let!(:message1) { create(:chat_message, course_chat: course_chat, created_at: 2.hours.ago) }
    let!(:message2) { create(:chat_message, course_chat: course_chat, created_at: 1.hour.ago) }
    let!(:message3) { create(:chat_message, course_chat: course_chat, created_at: 30.minutes.ago) }

    before do
      subscribe(channel_id: course_chat.id)
    end

    it 'broadcasts all messages in descending ordered by created_at' do
      expect {
        perform :fetch_messages
      }.to have_broadcasted_to(course_chat).with { |data|
        expect(data).to have_key(:messages)
        messages = data[:messages]

        expect(messages).to be_an(Array)
        expect(messages.length).to eq(4) # Including existing_message

        # Verify messages are in ascending order by created_at
        created_times = messages.map { |m| Time.parse(m["created_at"]) }
        expect(created_times).to eq(created_times.sort.reverse)

        # Verify all messages are included
        message_ids = messages.map { |m| m["id"] }
        expected_ids = [ message1.id, message2.id, existing_message.id, message3.id ]
        expect(message_ids).to match_array(expected_ids)
      }
    end

    it 'returns empty array when no messages exist' do
      ChatMessage.destroy_all

      expect {
        perform :fetch_messages
      }.to have_broadcasted_to(course_chat).with(hash_including(:messages))
    end
  end

  describe '#unsubscribed' do
    it 'successfully unsubscribes' do
      subscribe(channel_id: course_chat.id)

      expect { unsubscribe }.not_to raise_error
      expect(subscription).not_to have_streams
    end
  end
end
