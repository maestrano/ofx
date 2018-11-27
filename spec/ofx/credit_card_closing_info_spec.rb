require "spec_helper"

describe OFX::Parser::OFX102 do
  before do
    @ofx = OFX::Parser::Base.new("spec/fixtures/credit_card_closing_info.ofx")
    @parser = @ofx.parser
  end

  it "should set headers" do
    @parser.headers.should == @ofx.headers
  end

  it "should set body" do
    @parser.body.should == @ofx.body
  end

  it "should collect an array of credit card closing info" do
    @parser.credit_card_closing_info.should be_a(Array)
    @parser.credit_card_closing_info.size.should == 2
  end

  context "credit_card_closing_info" do
    # Test file contains one closing info. Let's check
    # them all.
    context "first credit card" do
      before do
        @credit_card_closing_info = @parser.credit_card_closing_info[0]
      end

      it "should contain the correct values" do
        @credit_card_closing_info.account_id.should == '4400720'
        @credit_card_closing_info.currency_default.should == 'USD'
        @credit_card_closing_info.fit_id.should == 'FITIDCCSTMT1399918849'
        @credit_card_closing_info.date_close.should == Time.gm(2018, 6, 4)
        @credit_card_closing_info.opening_balance.should == nil
        @credit_card_closing_info.closing_balance.should == -5859.08
        @credit_card_closing_info.payment_due_date.should == Time.gm(2018, 7, 1)
        @credit_card_closing_info.minimum_due_amount.should == 779
        @credit_card_closing_info.last_payment_date.should == Time.gm(2018, 2, 6)
        @credit_card_closing_info.last_payment_amount.should == 73
      end
    end

    context "second credit card" do
      before do
        @credit_card_closing_info = @parser.credit_card_closing_info[1]
      end

      it "should contain the correct values" do
        @credit_card_closing_info.account_id.should == '4400721'
        @credit_card_closing_info.currency_default.should == 'USD'
        @credit_card_closing_info.fit_id.should == 'FITIDCCSTMT1399928831'
        @credit_card_closing_info.last_payment_date.should == nil
        @credit_card_closing_info.last_payment_amount.should == nil
      end
    end
  end
end
