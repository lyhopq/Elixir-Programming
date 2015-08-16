defmodule World do
  def start do
    joe      = spawn(Person, :init, ["Joe"])
    susannah = spawn(Person, :init, ["SSusannah"])
    dave     = spawn(Person, :init, ["Dave"])
    andy     = spawn(Person, :init, ["Andy"])

    rover    = spawn(Dog, :init, ["Rover"])

    rabbit1  = spawn(Rabbit, :init, ["Flopsy"])
  end
end
