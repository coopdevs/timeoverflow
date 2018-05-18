Fabricator(:transfer) do
  source { Fabricate(:account) }
  destination { Fabricate(:account) }
  amount 10
end
