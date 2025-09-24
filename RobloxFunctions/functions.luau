return {
  mb1c = function(t, script) t.MouseButton1Click:Connect(script) end,
  flost = function(t, script) t.FocusLost:Connect(script) end,
  type = type or typeof,
  senv = getsenv or false,
  myfunc = {
    addnumber = function(t, number) return t += number end,
    removenum = function(t, number) return t = t - number end
  }
} -- JustForFun --
