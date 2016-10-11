nr = 12
str = "Marek"
final_str = ""
i = 0
x = 0
while i <= nr:
    x += 1
    final_str += str[x]
    if x == len(str):
        x = 0
    i += 1

print(final_str)