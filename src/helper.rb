class Helper
  def self.transliterate string
    conversions = {
      "á" => "a",
      "č" => "c",
      "ď" => "d",
      "é" => "e",
      "ě" => "e",
      "í" => "i",
      "ň" => "n",
      "ó" => "o",
      "ř" => "r",
      "š" => "s",
      "ť" => "t",
      "ú" => "u",
      "ů" => "u",
      "ý" => "y",
      "ž" => "z"
    }

    string.downcase.gsub(/[áčďéěíňóřšťúůýž]/, conversions).gsub(" ", "-")
  end
end