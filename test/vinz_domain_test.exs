defmodule VinzDomainTest do
  use ExUnit.Case

  test :join_domains do
    import Vinz.Domains, only: [ join: 1, join: 2 ]
    
    assert "" == join([])
    assert "a" == join(%w(a))
    assert "(a) and (b)" == join(%w(a b))
    assert "(a) and ((b) or (c))" == join([join(%w(a)), join(%w(b c), "or")])
  end
end
