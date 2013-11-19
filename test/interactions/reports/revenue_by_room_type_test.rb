require 'test_helper'

class Reports::RevenueByRoomTypeTest < ActiveSupport::TestCase

  
  def rev
    @rev ||= Reports::RevenueByRoomType.new context: @context
  end
  
  
  def sold room_type_id: nil, amount: 0.0, date: nil, bookable_type: "RoomType"
    b = Gen.booking!( hotel_id: hotel.id, bookable_id: room_type_id, paid: date, arrive: date, depart: date+1, rate: amount, bookable_type: bookable_type, state: "checked_in")
    Gen.sale!( hotel_id: hotel.id, booking_id: b.id, price: amount, total: amount, rate: amount, date: date, state: "checked_in")
  end
  
  def hotel
    return @hotel if @hotel
    @hotel = Gen.hotel!
    @hotel
  end

  def assert_count arr
    assert_equal Date.today.month, arr.size
  end
  
  context "a hotel with no packages or sales" do
    teardown do
      Timecop.return
    end
    setup do
      Timecop.freeze Time.local(2013, 03, 15, 11, 45)
      @room_types = [Gen.room_type!(id: 2, hotel_id: hotel.id)]
      @context = Context.new hotel: hotel
    end
    should "return an empty set" do
      res = rev.run
      rev = JSON.parse(res.revenue)
      book = JSON.parse(res.booking)
      assert_count rev
      assert_count book
      rev.each do |r|
        assert_equal 0, r["total"]
      end
      book.each do |r|
        assert_equal 0, r["total"]
      end
    end
  end
  
  
  context "a hotel with no packages and no sales and two room types" do
    teardown do
      Timecop.return
    end
    setup do
      Timecop.freeze Time.local(2013, 03, 15, 11, 45)

      @room_types = [Gen.room_type!( hotel_id: hotel.id)]
      @room_types << Gen.room_type!( hotel_id: hotel.id)
      @context = Context.new hotel: hotel
    end
    should "return an empty set with all rooms" do
      res = rev.run
      rev = JSON.parse(res.revenue)
      book = JSON.parse(res.booking)
      assert_count rev
      assert_count book
      rev.each do |r|
        assert_equal 0, r['total']
        assert_equal 0, r[@room_types[0].name]
        assert_equal 0, r[@room_types[1].name]
      end
      book.each do |r|
        assert_equal 0, r["total"]
        assert_equal 0, r[@room_types[0].name]
        assert_equal 0, r[@room_types[1].name]
      end
    end
  end
  
  
  
  context "a hotel with no packages but with sales and three room types" do    
    teardown do
      Timecop.return
    end
    setup do
      Timecop.freeze Time.local(2013, 03, 15, 11, 45)

      @room_types = [Gen.room_type!(hotel_id: hotel.id)]
      @room_types << Gen.room_type!(hotel_id: hotel.id)
      @room_types << Gen.room_type!(hotel_id: hotel.id)
      sold amount: 5.32, room_type_id: @room_types[0].id, date: Date.today - 30
      sold amount: 5.32, room_type_id: @room_types[1].id, date: Date.today - 30
      sold amount: 7.82, room_type_id: @room_types[1].id, date: Date.today - 30
      sold amount: 6.32, room_type_id: @room_types[0].id, date: Date.today
      sold amount: 4.32, room_type_id: @room_types[1].id, date: Date.today
      sold amount: 9.82, room_type_id: @room_types[1].id, date: Date.today
      @context = Context.new hotel: hotel
    end
    should "return good data" do
      res = rev.run
      rev = JSON.parse(res.revenue)
      book = JSON.parse(res.booking)
      assert_count rev
      assert_count book
      assert_equal 0, rev[0]["total"]
      assert_equal 0, rev[0][@room_types[0].name]
      assert_equal 0, rev[0][@room_types[1].name]
      assert_equal 0, rev[0][@room_types[2].name]
      assert_equal 18, rev[1]["total"]
      assert_equal 5,  rev[1][@room_types[0].name].to_d
      assert_equal 13, rev[1][@room_types[1].name].to_d
      assert_equal 0,  rev[1][@room_types[2].name].to_d
      assert_equal 20, rev[2]["total"]
      assert_equal 6,  rev[2][@room_types[0].name].to_d
      assert_equal 14, rev[2][@room_types[1].name].to_d
      assert_equal 0,  rev[2][@room_types[2].name].to_d
      
      assert_equal 0,  book[0]["total"]
      assert_equal 0,  book[0][@room_types[0].name]
      assert_equal 0,  book[0][@room_types[1].name]
      assert_equal 3, book[1]["total"]
      assert_equal 1,  book[1][@room_types[0].name]
      assert_equal 2, book[1][@room_types[1].name]
      assert_equal 3, book[2]["total"]            
      assert_equal 1,  book[2][@room_types[0].name]
      assert_equal 2, book[2][@room_types[1].name]
    end
  end
  
  
  context "a hotel with a packages and sales and two room types" do
    teardown do
      Timecop.return
    end
    setup do
      Timecop.freeze Time.local(2013, 03, 15, 11, 45)
      @room_types = [Gen.room_type!(hotel_id: hotel.id)]
      @room_types << Gen.room_type!(hotel_id: hotel.id)
      @room_types << Gen.room_type!(hotel_id: hotel.id)
      @package = Gen.package!( hotel_id: hotel.id, room_type_id: @room_types[0].id)
      
      sold amount: 5.32, room_type_id: @room_types[0].id, date: Date.today - 30
      sold amount: 5.32, room_type_id: @room_types[1].id, date: Date.today - 30
      sold amount: 7.82, room_type_id: @room_types[1].id, date: Date.today - 30
      sold amount: 2.43, room_type_id: @package.id, date: Date.today - 30, bookable_type: "Package"
      
      sold amount: 6.32, room_type_id: @room_types[0].id, date: Date.today
      sold amount: 4.32, room_type_id: @room_types[1].id, date: Date.today
      sold amount: 9.82, room_type_id: @room_types[1].id, date: Date.today
      sold amount: 8.43, room_type_id: @package.id, date: Date.today, bookable_type: "Package"
      @context = Context.new hotel: hotel
    end
    should "return good data" do
      res = rev.run
      rev = JSON.parse(res.revenue)
      book = JSON.parse(res.booking)
      assert_count rev
      assert_count book
      
      assert_equal 0, rev[0]["total"]
      assert_equal 0, rev[0][@room_types[0].name]
      assert_equal 0, rev[0][@room_types[1].name]
      assert_equal 0, rev[0][@room_types[2].name]
      assert_equal 20, rev[1]["total"]
      assert_equal 7,  rev[1][@room_types[0].name].to_d
      assert_equal 13, rev[1][@room_types[1].name].to_d
      assert_equal 0,  rev[1][@room_types[2].name].to_d
      assert_equal 28, rev[2]["total"]
      assert_equal 14, rev[2][@room_types[0].name].to_d
      assert_equal 14, rev[2][@room_types[1].name].to_d
      assert_equal 0,  rev[2][@room_types[2].name].to_d
      
      assert_equal 0,  book[0]["total"]
      assert_equal 0,  book[0][@room_types[0].name]
      assert_equal 0,  book[0][@room_types[1].name]
      assert_equal 4, book[1]["total"]
      assert_equal 2,  book[1][@room_types[0].name]
      assert_equal 2, book[1][@room_types[1].name]
      assert_equal 4, book[2]["total"]            
      assert_equal 2,  book[2][@room_types[0].name]
      assert_equal 2, book[2][@room_types[1].name]
    end
  end
  
  
  
end