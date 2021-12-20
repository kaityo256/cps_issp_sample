for i in range(10):
    filename = f"seed{i}.dat"
    with open(filename, "w") as f:
        f.write(str(i)+"\n")
        print(filename)
