Fabricator(:transfer) do
  source { Fabricate(:account) }
  destination { Fabricate(:account) }
  amount 600
end
