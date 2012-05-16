describe("Binflip", function () {

  beforeEach(function () {
    var body = document.getElementsByTagName('body')[0];
    body.setAttribute("data-features", '{"feature_on":true, "feature_off":false}');
  });

  it("should be true", function () {
    expect(Binflip.isActive("feature_on")).toEqual(true);
  });

  it("should be false", function () {
    expect(Binflip.isActive("feature_off")).toEqual(false);
  });

  it("should be false", function () {
    expect(Binflip.isActive("feature_unknown")).toEqual(false);
  });

});
