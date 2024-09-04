from time import sleep

COUNT=10

if __name__ == "__main__":
    print("Begin")
    for idx in range(COUNT):
        print(f"This is attempt number {idx}\n")
        print("--------------------------\n")
        sleep(0.5)
    print("All done")