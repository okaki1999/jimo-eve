require 'rails_helper'

RSpec.describe "Api::V1::Current::Events", type: :request do
  describe "GET api/v1/current/events" do
    subject { get(api_v1_current_events_path, headers:) }

    let(:headers) { current_user.create_new_auth_token }
    let(:current_user) { create(:user) }
    let(:other_user) { create(:user) }

    before { create_list(:event, 2, user: other_user) }

    context "ログインユーザーに紐づく events レコードが存在する時" do
      before { create_list(:event, 3, user: current_user) }

      it "正常にレコードを取得できる" do
        subject
        res = JSON.parse(response.body)
        expect(res.length).to eq 3
        expect(res[0].keys).to eq ["id", "title", "content", "status", "created_at", "from_today", "user"]
        expect(res[0]["user"].keys).to eq ["name"]
        expect(response).to have_http_status(:ok)
      end
    end

    context "ログインユーザーに紐づく events レコードが存在しない時" do
      it "空の配列が返る" do
        subject
        res = JSON.parse(response.body)
        expect(res).to eq []
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe "GET api/v1/current/events/:id" do
    subject { get(api_v1_current_event_path(id), headers:) }

    let(:headers) { current_user.create_new_auth_token }
    let(:current_user) { create(:user) }

    context ":id がログインユーザーに紐づく events レコードの id である時" do
      let(:current_user_event) { create(:event, user: current_user) }
      let(:id) { current_user_event.id }

      it "正常にレコードを取得できる" do
        subject
        res = JSON.parse(response.body)
        expect(res.keys).to eq ["id", "title", "content", "status", "created_at", "from_today", "user"]
        expect(res["user"].keys).to eq ["name"]
        expect(response).to have_http_status(:ok)
      end
    end

    context ":id がログインユーザーに紐づく events レコードの id ではない時" do
      let(:other_user_event) { create(:event) }
      let(:id) { other_user_event.id }

      it "例外が発生する" do
        expect { subject }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
  describe "POST api/v1/current/events" do
    subject { post(api_v1_current_events_path, headers:) }

    let(:headers) { current_user.create_new_auth_token }
    let(:current_user) { create(:user) }

    context "ログインユーザーに紐づく未保存ステータスの記事が0件の時" do
      it "未保存ステータスの記事が新規作成される" do
        expect { subject }.to change { current_user.events.count }.by(1)
        expect(current_user.events.last).to be_unsaved
        res = JSON.parse(response.body)
        expect(res.keys).to eq ["id", "title", "content", "status", "created_at", "from_today", "user"]
        expect(res["user"].keys).to eq ["name"]
        expect(response).to have_http_status(:ok)
      end
    end

    context "ログインユーザーに紐づく未保存ステータスの記事が1件の時" do
      before { create(:event, user: current_user, status: :unsaved) }

      it "未保存ステータスの記事が新規作成される" do
        expect { subject }.not_to change { current_user.events.count }
        res = JSON.parse(response.body)
        expect(res.keys).to eq ["id", "title", "content", "status", "created_at", "from_today", "user"]
        expect(res["user"].keys).to eq ["name"]
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe "PATCH api/v1/current/events" do
    subject { patch(api_v1_current_event_path(id), headers:, params:) }

    let(:headers) { current_user.create_new_auth_token }
    let(:current_user) { create(:user) }
    let(:other_user) { create(:user) }
    let(:params) { { "event": { "title": "テストタイトル2", "content": "テスト本文2", "status": "published" } } }

    context ":id がログインユーザーに紐づく events レコードの id である時" do
      let(:current_user_event) { create(:event, title: "テストタイトル1", content: "テスト本文1", status: :draft, user: current_user) }
      let(:id) { current_user_event.id }

      it "正常にレコードを更新できる" do
        expect { subject }.to change { current_user_event.reload.title }.from("テストタイトル1").to("テストタイトル2") and
          change { current_user_event.reload.content }.from("テスト本文1").to("テスト本文2") and
          change { current_user_event.reload.status }.from("draft").to("published")
        res = JSON.parse(response.body)
        expect(res.keys).to eq ["id", "title", "content", "status", "created_at", "from_today", "user"]
        expect(res["user"].keys).to eq ["name"]
        expect(response).to have_http_status(:ok)
      end
    end

    context ":id がログインユーザーに紐づく events レコードの id ではない時" do
      let(:other_user_event) { create(:event, user: other_user) }
      let(:id) { other_user_event.id }

      it "例外が発生する" do
        expect { subject }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
