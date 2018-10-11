# coding: utf-8
require "spec_helper"

describe UUIDParameter do
  let (:user_uuid)  { '8bb96d58-2efd-45df-833b-119971a19fea' }
  let (:other_uuid) { '8bb27724-7439-4965-9598-883419179b21' }

  it "generates a UUID for a new record" do
    user = User.new
    expect(user).to be_new_record
    expect(user.uuid).to be_nil
    expect(user.save).to be true
    expect(user.reload.uuid).not_to be_nil
  end

  it "keeps pre-assigned UUID intact (and silently ignores the change)" do
    user = User.create(uuid: user_uuid)
    expect(user.update_attribute(:uuid, other_uuid)).to be true
    expect(user.reload.uuid).to eql(user_uuid)
  end

  it "parameterizes model with UUID" do
    user = User.create(uuid: user_uuid)
    expect(user.to_param).to eql(user_uuid)
  end

  describe 'UUIDParameter validations' do
    let (:user_uuid)  { '8bb96d58-2efd-45df-833b-119971a19fea' }
    let (:other_uuid) { '8bb27724-7439-4965-9598-883419179b21' }
    let (:fake_uuid)  { '0be51de5-dead-babe-feed-b100d7e55bee' }
    let (:nil_uuid)   { '00000000-0000-0000-0000-000000000000' }
    let (:user)       { User.new }

    it "accepts UUID version 4" do
      user.uuid = user_uuid
      expect(user).to be_valid
    end

    it "rejects fake UUID" do
      user.uuid = fake_uuid
      expect(user).not_to be_valid
    end

    it "rejects non-v4 UUID" do
      user.uuid = nil_uuid
      expect(user).not_to be_valid
    end

    it "silently ignores attempts at changing existing UUID" do
      user.uuid = other_uuid
      expect(user.save).to be true
      user.uuid = user_uuid
      expect(user.save).to be true
      expect(user.uuid).to eql(other_uuid)
    end

    describe 'dealing with wrong records' do
      it 'assigns a valid uuid if the uuid is NULL in database' do
        user = User.create(uuid: user_uuid)
        expect(user.uuid).to eql(user_uuid)
        sql = "UPDATE users SET uuid = null WHERE users.id = #{user.id}"
        ActiveRecord::Base.connection.execute(sql)
        expect(user.reload.uuid).to be_nil
        expect(user.save).to be true
        expect(user.reload.uuid).not_to be_nil
        # sadly we cannot recover original UUID from this
        expect(user.uuid).not_to eql(user_uuid)
      end
      it 'provides an i18n error message for invalid UUID' do
        sql = "INSERT INTO users (uuid) VALUES ('#{fake_uuid}')"
        ActiveRecord::Base.connection.execute(sql)
        user = User.last
        expect(user.uuid).to eql(fake_uuid)
        expect(user).not_to be_valid
        # TODO: fix this when we figured out the I18n
        expect(user.errors.details[:uuid].first[:error]).to eq(:invalid_random_uuid)
      end
      it 'raises error if the uuid is invalid in database' do
        user = User.create(uuid: user_uuid)
        expect(user.uuid).to eql(user_uuid)
        [nil_uuid, fake_uuid].each do |invalid|
          sql = "UPDATE users SET uuid = '#{invalid}' WHERE users.id = #{user.id}"
          ActiveRecord::Base.connection.execute(sql)
          expect(user.reload).not_to be_valid
          expect(user.save).to be false
          expect { user.save! }.to raise_error(ActiveRecord::RecordInvalid)
        end
      end
    end

    describe 'translations' do
      it 'speaks 2 languages' do
        expect(I18n.available_locales.size).to eq(2)
      end
      it 'speaks English' do
        I18n.locale = :en
        expect(I18n.t('activerecord.errors.models.attributes.uuid.invalid_random_uuid')).to eq('must be a random UUID (v4)')
      end
      it 'parle français' do
        I18n.locale = :fr
        expect(I18n.t('activerecord.errors.models.attributes.uuid.invalid_random_uuid')).to eq('doit être un UUID aléatoire (v4)')
      end
    end
  end
end

