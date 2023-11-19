defmodule GoFish do
  @moduledoc """
  Documentation for `GoFish`.
  """

  require Integer
  alias GoFish.Cards

  def deal(player_ids) when length(player_ids) < 2, do: {:error, :not_enough_players}
  def deal(player_ids) when length(player_ids) > 6, do: {:error, :too_many_players}

  def deal(player_ids) do
    Enum.reduce(player_ids, {%{}, Cards.fresh_deck}, fn id, {hands, deck} ->
      {drawn, remaining_deck} = Cards.draw(deck, 5)
      {Map.put(hands, id, drawn), remaining_deck}
    end)
  end

  def ask_for(hand, rank) do
    with :not_found <- Cards.take_by_rank(hand, rank), do: :go_fish
  end

end
