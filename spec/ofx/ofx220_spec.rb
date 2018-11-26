require "spec_helper"

describe OFX::Parser::OFX220 do
  before do
    @ofx = OFX::Parser::Base.new("spec/fixtures/v220.ofx")
    @parser = @ofx.parser
  end

  it "should have a version" do
    OFX::Parser::OFX220::VERSION.should == "2.2.0"
  end

  it "should set headers" do
    @parser.headers.should == @ofx.headers
  end

  it "should set body" do
    @parser.body.should == @ofx.body
  end

  it "should collect an array of accounts info" do
    @parser.accounts_info.should be_a(Array)
    @parser.accounts_info.size.should == 5
  end

  context "accounts_info" do
    # Test file contains five transactions. Let's check
    # them all.
    context "first" do
      before do
        @acct_info = @parser.accounts_info[0]
      end

      it "should contain the correct values" do
        @acct_info.name.should == '...6915'
        @acct_info.description.should == 'DEBIT'
        @acct_info.bank_id.should == '123457890'
        @acct_info.id.should == '4298429'
        @acct_info.type.should == :checking
      end
    end

    context "second" do
      before do
        @acct_info = @parser.accounts_info[1]
      end

      it "should contain the correct values" do
        @acct_info.name.should == '...6931'
        @acct_info.description.should == 'SAVINGS'
        @acct_info.bank_id.should == '123457890'
        @acct_info.id.should == '4298428'
        @acct_info.type.should == :savings
      end
    end

    context "third" do
      before do
        @acct_info = @parser.accounts_info[2]
      end

      it "should contain the correct values" do
        @acct_info.name.should == '...9306'
        @acct_info.description.should == 'CREDIT CARD'
        @acct_info.bank_id.should == ''
        @acct_info.id.should == '4400720'
        @acct_info.type.should == :creditcard
      end
    end

    context "fourth" do
      before do
        @acct_info = @parser.accounts_info[3]
      end

      it "should contain the correct values" do
        @acct_info.name.should == '...4220'
        @acct_info.description.should == 'BUSINESS LOC'
        @acct_info.bank_id.should == '123457890'
        @acct_info.id.should == '4247835'
        @acct_info.type.should == :creditline
      end
    end

    context "fifth" do
      before do
        @acct_info = @parser.accounts_info[4]
      end

      it "should contain the correct values" do
        @acct_info.name.should == '...0200'
        @acct_info.description.should == 'BUSINESS LOAN'
        @acct_info.bank_id.should == '123457890'
        @acct_info.id.should == '4247835'
        @acct_info.type.should == :creditline
      end
    end
  end
end
