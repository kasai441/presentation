require 'spec_helper'

describe StudiesController do
    it "is valid with get_chart_list_service" do
        seq = Study.all
        other_keys = ['unity', 'connpass', 'cobol', 'vba']
        start_day = '2018-02-01'
        get_chart_list_service = new GetChartListService(seq, other_keys, start_day)
        expect(get_chart_list_service.get_list).to be_valid
      end
end
