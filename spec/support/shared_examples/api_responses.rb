
shared_examples "returns success response" do
  it "returns http success" do
    expect(response).to have_http_status(:success)
  end
  
  it "returns valid JSON response with serialized data" do
    expect(response.parsed_body).to eq(expected_response)
  end
end


shared_examples "returns not found response" do
  it "returns not found status" do
    expect(response).to have_http_status(:not_found)
  end
  
  it "returns record not found error message" do
    expect(response.parsed_body).to eq({ "error" => "Record not found" })
  end
end

shared_examples "returns unprocessable entity response" do
  it "returns unprocessable entity status" do
    expect(response).to have_http_status(:unprocessable_entity)
  end

  it "returns error message" do
    expect(response.parsed_body).to eq({ "errors" => expected_errors })
  end
end


shared_examples "does not create record" do |model_class|
  it "does not create a #{model_class.name.downcase}" do
    expect(model_class.count).to eq(0)
  end
end