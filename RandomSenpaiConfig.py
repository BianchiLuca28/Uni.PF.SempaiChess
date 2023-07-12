import math
import os
import random

limit_constant = 14 # Costante per il calcolo del numero massimo di senpai e oggetti in base a N
n = 10  # Dimensione della matrice
loop_number = 10  # Numero di configurazioni da generare
output_file = "./Input.lua"  # Nome del file di output
should_N_be_written = True  # Se True scrive N_n nel file di output
can_multiple_senpai_be_in_same_position = False  # Se True permette a più senpai di essere nella stessa posizione
can_multiple_objects_be_in_same_position = True  # Se True permette a più oggetti di essere nella stessa posizione


def generate_senpai(N):
    senpai_list = []
    limit = limit_formula(N)
    num_senpai = random.randint(1, limit)  # Numero casuale di senpai
    positions = set()  # Insieme delle posizioni occupate
    while len(senpai_list) < num_senpai:
        x = random.randint(0, N - 1)
        y = random.randint(0, N - 1)
        if not can_multiple_senpai_be_in_same_position:
            if (x, y) not in positions:
                senpai_list.append([x, y, 0, 0, 0, 0])
                positions.add((x, y))
        else:
            senpai_list.append([x, y, 0, 0, 0, 0])
    return senpai_list


def limit_formula(n):
    return math.floor(((n * n) / limit_constant))


def generate_configuration(N):
    senpai_list = generate_senpai(N)
    configuration = {'S': senpai_list,
                     'U': [],
                     'C': [],
                     'G': [],
                     'R': []}
    if not can_multiple_objects_be_in_same_position:
        positions = set()
    else:
        positions = list()
    limit = limit_formula(N)
    obj_num = random.randint(1, limit)  # Numero casuale di oggetti
    while len(positions) < obj_num:
        x = random.randint(0, N - 1)
        y = random.randint(0, N - 1)
        if not can_multiple_objects_be_in_same_position:
            if (x, y) not in positions:
                positions.add((x, y))
        else:
            positions.append((x, y))
    for position in positions:
        x = position[0]
        y = position[1]
        configuration[get_random_type()].append([x, y])
    return configuration


def get_random_type():
    letters = ['U', 'C', 'G', 'R']
    random_letter = random.choice(letters)
    return random_letter


def format_configuration(configuration, index):
    formatted = "\t\tlocal D" + str(index + 1) + " = {\n"
    formatted += "\t\tS = {"
    for senpai in configuration['S']:
        formatted += "{" + str(senpai[0]) + ", " + str(senpai[1]) + ", " + str(senpai[2]) + ", " + str(
            senpai[3]) + ", " + str(senpai[4]) + ", " + str(senpai[5]) + "}, "
    formatted = formatted[:-2] + "},\n"

    formatted += "\t\t\tU = {"
    for u in configuration['U']:
        formatted += "{" + str(u[0]) + ", " + str(u[1]) + "}, "
    if len(configuration['U']) > 0:
        formatted = formatted[:-2]
    formatted += "},\n"

    formatted += "\t\t\tC = {"
    for c in configuration['C']:
        formatted += "{" + str(c[0]) + ", " + str(c[1]) + "}, "
    if len(configuration['C']) > 0:
        formatted = formatted[:-2]
    formatted += "},\n"

    formatted += "\t\t\tG = {"
    for g in configuration['G']:
        formatted += "{" + str(g[0]) + ", " + str(g[1]) + "}, "
    if len(configuration['G']) > 0:
        formatted = formatted[:-2]
    formatted += "},\n"

    formatted += "\t\t\tR = {"
    for r in configuration['R']:
        formatted += "{" + str(r[0]) + ", " + str(r[1]) + "}, "
    if len(configuration['R']) > 0:
        formatted = formatted[:-2]
    formatted += "}\n"

    return formatted + "\t\t}\n\n"


def write(string):
    with open(output_file, "w") as file:
        file.write(string)


def delete_file_if_exists():
    if os.path.exists(output_file):
        os.remove(output_file)


def loop():
    conf = "function loadConfig()\n"
    for i in range(loop_number):
        if should_N_be_written:
            conf += "\t\tlocal N" + str(i + 1) + " = " + str(n) + "\n"
        conf += format_configuration(generate_configuration(n), i)
    delete_file_if_exists()
    conf += "\t\tlocal configs = {}\n\n"
    if not should_N_be_written:
        for k in range(loop_number):
            conf += "\t\tconfigs[" + str(k + 1) + "]" + " = D" + str(k + 1) + "\n"
    else:
        for k in range(loop_number):
            conf += "\t\tconfigs[" + str(k + 1) + "]" + " = {N = N" + str(k + 1) + ", D = D" + str(k + 1) + "}\n"
    conf += "\n\t\treturn configs\n"
    conf += "end\n"
    write(conf)


def main():
    loop()


if __name__ == '__main__':
    main()
