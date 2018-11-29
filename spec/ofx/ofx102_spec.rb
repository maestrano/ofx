require "spec_helper"

describe OFX::Parser::OFX102 do
  before do
    @ofx = OFX::Parser::Base.new("spec/fixtures/sample.ofx")
    @parser = @ofx.parser
  end
  
  it "should have a version" do
    OFX::Parser::OFX102::VERSION.should == "1.0.2"
  end
  
  it "should set headers" do
    @parser.headers.should == @ofx.headers
  end

  it "should trim trailing whitespace from headers" do
    headers = OFX::Parser::OFX102.parse_headers("VERSION:102   ")
    headers["VERSION"].should == "102"
  end

  it "should set body" do
    @parser.body.should == @ofx.body
  end
  
  it "should set account" do
    @parser.account.should be_a_kind_of(OFX::Account)
  end

  it "should set account" do
    @parser.sign_on.should be_a_kind_of(OFX::SignOn)
  end

  it "should set statements" do
    @parser.statements.size.should == 1
    @parser.statements.first.should be_a_kind_of(OFX::Statement)
  end

  it "should know about all transaction types" do
    valid_types = [
      'CREDIT', 'DEBIT', 'INT', 'DIV', 'FEE', 'SRVCHG', 'DEP', 'ATM', 'POS', 'XFER', 
      'CHECK', 'PAYMENT', 'CASH', 'DIRECTDEP', 'DIRECTDEBIT', 'REPEATPMT', 'OTHER'
    ]
    valid_types.sort.should == OFX::Parser::OFX102::TRANSACTION_TYPES.keys.sort
    
    valid_types.each do |transaction_type|
      transaction_type.downcase.to_sym.should equal OFX::Parser::OFX102::TRANSACTION_TYPES[transaction_type]
    end
  end

  context 'creditcard accounts' do
    before do
      @ofx = OFX::Parser::Base.new("spec/fixtures/creditcard.ofx")
      @parser = @ofx.parser
    end

    it "should set account type" do
      @parser.account.type.should == :creditcard
    end

  end

  context 'creditline accounts' do
    before do
      @ofx = OFX::Parser::Base.new("spec/fixtures/creditline.ofx")
      @parser = @ofx.parser
    end

    it "should set account type" do
      @parser.account.type.should == :creditline
    end

    it 'should parse the transactions correctly' do
      transaction = @parser.account.transactions.first
      transaction.name.should == 'Payment'
      transaction.extdname.should == 'Payment'
      transaction.amount_in_pennies.should == 39146
      transaction.type.should == :payment
      transaction.fit_id.should == '161706996'

      @parser.account.type.should == :creditline
    end
  end

  describe "#build_date" do
    context "without a Time Zone" do
      it "should default to GMT" do
        @parser.send(:build_date, "20170904").should == Time.gm(2017, 9, 4)
        @parser.send(:build_date, "20170904082855").should == Time.gm(2017, 9, 4, 8, 28, 55)
      end
    end

    context "with a Time Zone" do
      it "should returns the correct date" do
        @parser.send(:build_date, "20150507164333[-0300:BRT]").should == Time.new(2015, 5, 7, 16, 43, 33, "-03:00")
        @parser.send(:build_date, "20180507120000[0:GMT]").should == Time.gm(2018, 5, 7, 12)
        @parser.send(:build_date, "20170904082855[-3:GMT]").should == Time.new(2017, 9, 4, 8, 28, 55, "-03:00")
      end
    end
  end 
end
