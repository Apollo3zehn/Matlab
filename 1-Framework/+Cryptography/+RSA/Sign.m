function Signature = Sign(Modulus, PrivateExponent, Message)
    Signature = NumberTheory.ModularExponentiation(Message, PrivateExponent, Modulus);
end