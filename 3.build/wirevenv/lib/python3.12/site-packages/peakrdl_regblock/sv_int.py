from typing import Optional

class SVInt:
    def __init__(self, value: int, width: Optional[int] = None) -> None:
        self.value = value
        self.width = width

    def __str__(self) -> str:
        if self.width is not None:
            # Explicit width
            return f"{self.width}'h{self.value:x}"
        elif self.value.bit_length() > 32:
            # SV standard only enforces that unsized literals shall be at least 32-bits
            # To support larger literals, they need to be sized explicitly
            return f"{self.value.bit_length()}'h{self.value:x}"
        else:
            return f"'h{self.value:x}"
