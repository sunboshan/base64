defmodule Base64Test do
  use ExUnit.Case
  doctest Base64

  test "encode empty" do
    assert Base64.encode("") == ""
  end

  test "encode random ASCII" do
    for _ <- 1..100 do
      rands = random()
      assert Base64.encode(rands) == Base.encode64(rands)
    end
  end

  test "encode unicode" do
    assert Base64.encode("你好世界") == "5L2g5aW95LiW55WM"
    assert Base64.encode("😀") == "8J+YgA=="
  end

  test "decode empty" do
    assert Base64.decode!("") == ""
  end

  test "decode unicode" do
    assert Base64.decode!("5L2g5aW95LiW55WM") == "你好世界"
    assert Base64.decode!("8J+YgA==") == "😀"
  end

  test "decode error" do
    assert_raise ArgumentError, fn ->
      Base64.decode!("error")
    end
  end

  test "decode random ASCII" do
    for _ <- 1..100 do
      rands = random()
      assert Base64.decode(Base.encode64(rands)) == {:ok, rands}
    end
  end

  defp random do
    for _ <- 1..:rand.uniform(100), into: <<>>, do: <<Enum.random(0..127)>>
  end
end
