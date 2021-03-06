require 'spec_helper'

describe SMS do
  it "can look up users by pcv id" do
    user   = create :user
    supply = create :supply
    m = SMS.new text: "@#{user.pcv_id} #{supply.shortcode}"
    expect( m.user ).to eq user
  end

  it "can fail to find users" do
    expect do
      supply = create :supply
      SMS.new(text: "@XXXX #{supply.shortcode}").create_orders!
    end.to raise_friendly_error /can't find user/i
  end

  it "can fail to find supplies for a specific user's country" do
    expect do
      user = create :user
      supply = create :supply
      SMS.new(text: "@#{user.pcv_id} #{supply.shortcode}").create_orders!
    end.to raise_friendly_error /for country/i
  end

  it "can abridge the confirmation message if it's too long" do
    n = 12
    user = create :user
    n.times do 
      supply = create :supply
      user.country.supplies << supply
    end

    m = SMS.new text: "@#{user.pcv_id} #{Supply.last(n).map(&:shortcode).join ' '}", created_at: Time.now
    expect( m.confirmation_message.length ).to be < 160
    expect( m.confirmation_message ).to match /#{n - 1} other/
  end
end
