defmodule GoFish.Cards do
  require Integer

  @cards (
    for suit <- [:spades, :hearts, :diamonds, :clubs],
        rank <- [2, 3, 4, 5, 6, 7, 8, 9, 10, :jack, :queen, :king, :ace],
      do: %{suit: suit, rank: rank}
  )

  def fresh_deck(), do:
    Enum.shuffle(@cards)

  def draw([card | rest]), do:
    {:ok, card, rest}
  def draw([]), do:
    {:error, :empty}

  def draw(cards, count) when count < 1, do:
    {[], cards}

  def draw(cards, count) do
    {drawn, remaining} = Enum.reduce(1..count, {[], cards}, fn _, {drawn, cards} ->
      {:ok, card, remaining} = draw(cards)
      {[card | drawn], remaining}
    end)
    {Enum.reverse(drawn), remaining}
  end

  def take_by_rank(cards, rank) do
    case Enum.find(cards, fn %{rank: card_rank} -> card_rank == rank end) do
      nil -> :not_found
      card -> {:ok, card, Enum.filter(cards, &(&1 != card))}
    end
  end

  def split_in_pairs(cards) do
    Enum.group_by(cards, fn %{rank: rank} -> rank end)
      |> Map.values()
      |> Enum.flat_map(fn matches -> Enum.chunk_every(matches, 2) end)
      |> Enum.map(fn single_or_pair ->
        case single_or_pair do
          [a, b] -> {a, b}
          [a] -> a
        end
      end)
      |> Enum.split_with(fn single_or_pair -> match?(%{}, single_or_pair) end)
  end
end
