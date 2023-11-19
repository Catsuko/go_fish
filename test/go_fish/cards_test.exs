# TODO: How can I organize these tests better?
defmodule GoFish.CardsTest do
  use ExUnit.Case, async: true

  alias GoFish.Cards

  test "provides a full deck of cards" do
    assert length(Cards.fresh_deck) == 52
  end

  test "draws a single card from the deck" do
    {:ok, card, deck} = Cards.draw(Cards.fresh_deck)
    assert length(deck) == 51
    assert %{suit: _, rank: _} = card
  end

  test "doesn't draw from an empty deck" do
    assert {:error, :empty} = Cards.draw([])
  end

  test "draws nothing with a count of 0" do
    {drawn, deck} = Cards.draw(Cards.fresh_deck, 0)
    assert length(drawn) == 0
    assert length(deck) == 52
  end

  test "draws multiple cards" do
    amount_to_draw = 17
    {drawn, deck} = Cards.draw(Cards.fresh_deck, amount_to_draw)
    assert length(drawn) == amount_to_draw
    assert length(deck) == 52 - amount_to_draw
  end

  test "draws the whole deck" do
    {drawn, deck} = Cards.draw(Cards.fresh_deck, 52)
    assert length(drawn) == 52
    assert length(deck) == 0
  end

  test "takes a card by rank" do
    assert {:ok, %{rank: 2}, cards} = Cards.take_by_rank(Cards.fresh_deck, 2)
    assert length(cards) == 51
  end

  test "cannot take by rank when it is missing" do
    deck_without_aces = Cards.fresh_deck()
      |> Enum.filter(fn %{rank: rank} -> rank != :ace end)
    assert :not_found = Cards.take_by_rank(deck_without_aces, :ace)
  end

  test "cannot take from empty deck" do
    assert :not_found = Cards.take_by_rank([], 2)
  end

  test "splits empty list into pairs" do
    assert {[], []} = Cards.split_in_pairs([])
  end

  test "finds no pairs for unique list" do
    clubs_cards = Cards.fresh_deck()
      |> Enum.filter(fn %{suit: suit} -> suit == :clubs end)
    assert {unmatched, []} = Cards.split_in_pairs(clubs_cards)
    assert Enum.sort(unmatched) == Enum.sort(clubs_cards)
  end

  test "matches all cards into pairs for a fresh deck" do
    {[], pairs} = Cards.fresh_deck()
      |> Cards.split_in_pairs()
    assert length(pairs) == 26
  end

end
