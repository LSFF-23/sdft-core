import math

OFFSET = 32768
CORRECTION = 2*OFFSET
BUFFER = 64

print("Started.")

with open("rom_cos.hex", "w") as c, open("rom_sin.hex", "w") as s:
    for i in range(BUFFER):
        cv = math.floor(math.cos(2*math.pi*i/BUFFER)*OFFSET + 0.5)
        sv = math.floor(math.sin(2*math.pi*i/BUFFER)*OFFSET + 0.5)
        if (cv == 32768): cv = 32767
        if (sv == 32768): sv = 32767
        mcv = cv + CORRECTION if cv < 0 else cv
        msv = sv + CORRECTION if sv < 0 else sv
        c.write(f"{mcv:04X}{'\n' if i != (BUFFER-1) else ''}")
        s.write(f"{msv:04X}{'\n' if i != (BUFFER-1) else ''}")

print("Done.")
