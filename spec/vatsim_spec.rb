require 'spec_helper'

describe Vatsim::VERSION do
  it "should return a non nil version" do
    Vatsim::VERSION.should_not == nil
 end
end

describe Vatsim::Airport do
  it "should return correct Airport" do
    airport = Vatsim::Airport.get("CYYC")
    airport.should_not == nil
    airport.icao.should == "CYYC"
    airport.latitude.should == "51.113899230957"
    airport.longitude.should == "-114.019996643066"
  end

  it "should return nil Airport" do
    Vatsim::Airport.get("NONE").should == nil
  end

end
describe Vatsim::Data do

  before do
    WebMock.disable_net_connect!
    File.delete(Vatsim::Data::STATUS_FILE_PATH) if File.exists?(Vatsim::Data::STATUS_FILE_PATH)
    File.delete(Vatsim::Data::DATA_FILE_PATH) if File.exists?(Vatsim::Data::DATA_FILE_PATH)
    stub_request(:get, "http://status.vatsim.net/status.txt").to_return(:body => File.new(File.dirname(__FILE__) + "/vatsim-status.txt"))
    stub_request(:get, "http://www.net-flyer.net/DataFeed/vatsim-data.txt").to_return(:body => File.new(File.dirname(__FILE__) + "/vatsim-data.txt"))
    stub_request(:get, "http://www.klain.net/sidata/vatsim-data.txt").to_return(:body => File.new(File.dirname(__FILE__) + "/vatsim-data.txt"))
    stub_request(:get, "http://fsproshop.com/servinfo/vatsim-data.txt").to_return(:body => File.new(File.dirname(__FILE__) + "/vatsim-data.txt"))
    stub_request(:get, "http://info.vroute.net/vatsim-data.txt").to_return(:body => File.new(File.dirname(__FILE__) + "/vatsim-data.txt"))
    stub_request(:get, "http://data.vattastic.com/vatsim-data.txt").to_return(:body => File.new(File.dirname(__FILE__) + "/vatsim-data.txt"))
  end

  it "should return correct number of pilots, prefiles, servers, and atc" do
    data = Vatsim::Data.new
    data.pilots.length.should equal(379)
    data.atc.length.should equal(122)
    data.servers.length.should equal(8)
    data.voice_servers.length.should equal(11)
    data.prefiles.length.should equal(6)
  end

  it "should return correct values for general properties" do
    data = Vatsim::Data.new
    data.general.length.should equal(5)
    data.general["version"].should == "8"
    data.general["reload"].should == "2"
    data.general["update"].should == "20120504011745"
    data.general["atis_allow_min"].should == "5"
    data.general["connected_clients"].should == "502"
  end

  it "should return correct values for a specific pilot" do
    data = Vatsim::Data.new
    pilot = data.pilots[19]
    pilot.callsign.should == "ACA021"
    pilot.cid.should == "1216364"
    pilot.realname.should == "Sam Bouz CYUL"
    pilot.clienttype.should == "PILOT"
    pilot.latitude.should == "52.36574"
    pilot.longitude.should == "38.94341"
    pilot.altitude.should == "33799"
    pilot.groundspeed.should == "486"
    pilot.planned_aircraft.should == "H/A333"
    pilot.planned_tascruise.should == "480"
    pilot.planned_depairport.should == "UUEE"
    pilot.planned_altitude.should == "FL340"
    pilot.planned_destairport.should == "LTAC"
    pilot.server.should == "EUROPE-CW2"
    pilot.protrevision.should == "100"
    pilot.rating.should == "1"
    pilot.transponder.should == "3437"
    pilot.planned_revision.should == "0"
    pilot.planned_flighttype.should == "I"
    pilot.planned_deptime.should == "0"
    pilot.planned_actdeptime.should == "0"
    pilot.planned_hrsenroute.should == "2"
    pilot.planned_minenroute.should == "38"
    pilot.planned_hrsfuel.should == "4"
    pilot.planned_minfuel.should == "7"
    pilot.planned_altairport.should == "LTBA"
    pilot.planned_remarks.should == " /T/"
    pilot.planned_route.should == "KS LUKOS 6E8 LO 6E18 DK CRDR6 FV R11 TS R808 UUOO R368 KUBOK UA279 GR UP29 SUMOL UW100 INB UM853 BUK UW71 ILHAN"
    pilot.planned_depairport_lat.should == "55.972599029541"
    pilot.planned_depairport_lon.should == "37.4146003723145"
    pilot.planned_destairport_lat.should == "40.1281013489"
    pilot.planned_destairport_lon.should == "32.995098114"
    pilot.time_logon.should == "20120503235431"
    pilot.heading.should == "169"
    pilot.QNH_iHg.should == "29.7"
    pilot.QNH_Mb.should == "1005"
  end

  it "should return correct values for a specific prefile" do
    data = Vatsim::Data.new
    prefile = data.prefiles[1]
    prefile.callsign.should == "DAV10674"
    prefile.cid.should == "1207105"
    prefile.realname.should == "Randy Harrill KCMO"
    prefile.planned_aircraft.should == "T/MD90/W"
    prefile.planned_tascruise.should == "360"
    prefile.planned_depairport.should == "KATL"
    prefile.planned_altitude.should == "F290"
    prefile.planned_destairport.should == "KMIA"
    prefile.planned_revision.should == "0"
    prefile.planned_flighttype.should == "I"
    prefile.planned_deptime.should == "45"
    prefile.planned_actdeptime.should == "45"
    prefile.planned_hrsenroute.should == "1"
    prefile.planned_minenroute.should == "50"
    prefile.planned_hrsfuel.should == "2"
    prefile.planned_minfuel.should == "50"
    prefile.planned_altairport.should == "KPBI"
    prefile.planned_remarks.should == "+VFPS+/V/ "
    prefile.planned_route.should == "THRSR6 LUCKK SZW SSCOT1"
    prefile.planned_depairport_lat.should == "0"
    prefile.planned_depairport_lon.should == "0"
    prefile.planned_destairport_lat.should == "0"
    prefile.planned_destairport_lon.should == "0"
  end

  it "should return correct values for a specific ATC" do
    data = Vatsim::Data.new
    atc = data.atc[20]
    atc.callsign.should == "CZEG_CTR"
    atc.cid.should == "1096034"
    atc.realname.should == "Brett Zubot"
    atc.clienttype.should == "ATC"
    atc.frequency.should == "132.850"
    atc.latitude.should == "53.18500"
    atc.longitude.should == "-113.86667"
    atc.server.should == "USA-N"
    atc.protrevision.should == "100"
    atc.rating.should == "5"
    atc.facilitytype.should == "6"
    atc.visualrange.should == "600"
    atc.time_logon.should == "20120504004825"
  end

  it "should return correct values for a specific server" do
    data = Vatsim::Data.new
    server = data.servers[6]
    server.ident.should == "USA-N"
    server.hostname_or_IP.should == "204.244.237.21"
    server.location.should == "Vancouver, CANADA"
    server.name.should == "USA North"
    server.clients_connection_allowed.should == "1"
  end

  it "should return correct values for a specific voice server" do
    data = Vatsim::Data.new
    voice_server = data.voice_servers[4]
    voice_server.hostname_or_IP.should == "voice.zhuartcc.net"
    voice_server.location.should == "Sponsored by Houston ARTCC"
    voice_server.name.should == "ZHU-ARTCC"
    voice_server.clients_connection_allowed.should == "1"
    voice_server.type_of_voice_server.should == "R"
  end

end

