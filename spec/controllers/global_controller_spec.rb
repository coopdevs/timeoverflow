require 'spec_helper'

describe GlobalController do
  include_context "stub browser locale"
  before { set_browser_locale('it') }

  describe "User not logged and GET 'switch_lang' using browser's locale" do
    subject { get 'switch_lang' }

    context 'browser in spanish' do
      it "redirects to spanish home" do
        # We stub the method that extracts browsers language info and force to return expected value for
        # context
        set_browser_locale('es')

        #response.should redirect to home spanish
        subject.should redirect_to('/home')
      end
    end

    context 'browser in catalan' do
      it "redirects to spanish home" do
        # We stub the method that extracts browsers language info and force to return expected value for
        # context
        set_browser_locale('ca')

        #response.should redirect to home catalan
        subject.should redirect_to('/home_ca')
      end
    end

    context 'broser in english' do
      it "redirects to spanish home" do
        # We stub the method that extracts browsers language info and force to return expected value for
        # context
        set_browser_locale('en')

        #response.should redirect to home english
        subject.should redirect_to('/home_en')
      end
    end

    context 'browser in non-supported language' do
      it "redirects to spanish default home" do
        # We stub the method that extracts browsers language info and force to return expected value for
        # context
        # We stub to an invalid locale to check it redirects to the right default one
        set_browser_locale('fr')

        #response.should redirect to default home (spanish)
        subject.should redirect_to('/home')
      end
    end
  end

  describe "User not logged and GET 'switch_lang' by selection in navbar in english" do
    subject { get 'switch_lang', {:locale => 'en'} }

    it "redirects to english home" do
       #response.should redirect to home_en
       subject.should redirect_to('/home_en')
    end
  end

  describe "User not logged and GET 'switch_lang' by selection in navbar in spanish" do
    subject { get 'switch_lang', {:locale =>  'es'} }

    it "redirects to spanish home" do
        #response.should redirect to home (spanish)
        subject.should redirect_to('/home')
    end
  end

  describe "User not logged and GET 'switch_lang' by selection in navbar in catalan" do
    subject { get 'switch_lang', {:locale => 'ca'} }
    it "redirects to catalan home" do
        #response.should redirect to home_ca
        subject.should redirect_to('/home_ca')
    end
  end


  #
  # Now with user logged in in different default browser languages
  #

  describe "User logged and GET 'switch_lang' using browser's locale" do

    let! (:test_organization) { Fabricate(:organization)}
    let! (:member) { Fabricate(:member, organization: test_organization) }

    context 'browser in spanish' do
      it "redirects to spanish offers page" do
        # We stub the method that extracts browsers language info and force to return expected value for
        # context
        set_browser_locale('es')

        login(member.user)
        visit offers_path

        current_path.should == "/offers"

        page.body.should include('Ofertas')
      end
    end

    context 'browser in catalan' do
      it "redirects to catalan offers page" do
        # We stub the method that extracts browsers language info and force to return expected value for
        # context
        set_browser_locale('ca')

        login(member.user)
        visit offers_path

        current_path.should == "/offers"

        page.body.should include('Ofertes')
      end
    end

    context 'browser in catalan' do
      it "redirects to catalan offers page" do
        # We stub the method that extracts browsers language info and force to return expected value for
        # context
        set_browser_locale('en')

        login(member.user)
        visit offers_path

        current_path.should == "/offers"

        page.body.should include('Offers')
      end
    end
  end

  #
  # Now with user logged in having selected language
  #

  describe "User logged and GET 'switch_lang' using browser's locale" do

    let! (:test_organization) { Fabricate(:organization)}
    let! (:member) { Fabricate(:member, organization: test_organization) }

    context 'user clicks in Spanish flag' do
      it "redirects to spanish offers page" do
        
        visit '/'
        click_link 'es_flag'
        login(member.user)
        visit offers_path

        current_path.should == "/offers"
        page.body.should include('Ofertas')
      end
    end

    context 'user clicks in English flag' do
      it "redirects to catalan offers page" do

        visit '/'
        click_link 'en_flag'
        login(member.user)
        visit offers_path

        current_path.should == "/offers"
        page.body.should include('Offers')
      end
    end

    context 'user clicks in catalan flag' do
      it "redirects to catalan offers page" do

        visit '/'
        click_link 'ca_flag'
        login(member.user)
        visit offers_path

        current_path.should == "/offers"
        page.body.should include('Ofertes')
      end
    end
  end
end
