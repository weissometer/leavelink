class Report::PcmoResponseTimes < Report
  def initialize orders
    self.rows = orders.includes :country, :supply, :response, :user => :phones
  end

  def format order
    supply  = order.supply
    country = order.country
    user    = order.user
    phone   = user.primary_phone

    {
      "User ID"       => order.user_id,
      "Order ID"      => order.id,
      "Placed"        => order.created_at,
      "Responded"     => order.responded_at,
      "First name"    => user.first_name,
      "Last name"     => user.last_name,
      "Email"         => user.email,
      "Phone"         => phone.try(:number),
      "Supply Type"   => supply.name,
      "Location"      => user.location,
      "Country"       => country.name,
      "Response Days" => order.response_time,
      "Past Due"      => order.how_past_due
    }
  end
end
