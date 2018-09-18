require "spec_helper"

describe UUIDParameter do
  let (:user_uuid)  { '8bb96d58-2efd-45df-833b-119971a19fea' }
  let (:user)       { User.new }

  it "generates a UUID for a new record" do
    expect(user).to be_new_record
    expect(user.uuid).to be_nil
    expect(user.save).to be true
    expect(user.uuid).not_to be_nil
  end

  it "keeps existing UUID intact" do
    expect(user).to be_new_record
    user.uuid = user_uuid
    expect(user.save).to be true
    expect(user.uuid).to eql(user_uuid)
  end

  it "parameterizes model with UUID" do
    user = User.create(uuid: user_uuid)
    expect(user.to_param).to eql(user_uuid)
  end
end

describe UUIDParameter::UUIDVersion4Validator do
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
end
