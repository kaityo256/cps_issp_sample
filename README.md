# CPSを物性研で使うサンプル

## 概要

手抜き馬鹿パラスケジューラ「Command Processor Scheduler (CPS)」を物性研で利用するためのサンプル。CPSのリポジトリは[github.com/kaityo256/cps](https://github.com/kaityo256/cps)

## 使い方

### 準備

このリポジトリを`--recursive`をつけて`clone`する。

```sh
git clone --recursive https://github.com/kaityo256/cps_issp_sample.git
```

できたディレクトリの`cps_issp_sample/cps`に入る。

```sh
cd cps_issp_sample
cd cps
```

`cps`をビルドする。

```sh
make
```

`cps`ができたら上に戻る。

```sh
cd ..
```

インプットファイル`seed?.dat`を作成する。

```sh
python3 makeseed.py
```

`seed0.dat`から`seed9.dat`ができるはず。これでジョブを投入する準備ができた。

### ジョブの投入

実行するタスクは`task.sh`に書いてある。

```sh
# tasks
python3 hello.py < seed0.dat > output0.dat
python3 hello.py < seed1.dat > output1.dat
python3 hello.py < seed2.dat > output2.dat
python3 hello.py < seed3.dat > output3.dat
python3 hello.py < seed4.dat > output4.dat
python3 hello.py < seed5.dat > output5.dat
python3 hello.py < seed6.dat > output6.dat
python3 hello.py < seed7.dat > output7.dat
python3 hello.py < seed8.dat > output8.dat
python3 hello.py < seed9.dat > output9.dat
```

それぞれのジョブは5秒かかる。これを10並列で実行するジョブスクリプトが`job.sh`。

```sh
#!/bin/sh

#SBATCH -p i8cpu
#SBATCH -N 1
#SBATCH -n 11

srun ./cps/cps task.sh
```

これはテストなので`i8cpu`を使っているが、プロダクトランを投げる時には`F1cpu`キューなどに投げること。ノード数は1(`-N 1`)、プロセス数は11 (`-n 11`)としている。CPSは管理のために1プロセス使うので、ジョブスクリプトに書いたプロセス数-1が並列実行される。

このジョブを投入するには`sbatch`を用いる。

```sh
sbatch job.sh
```

実行終了後、以下のような`cps.log`が出力されたら成功。

```txt
Number of tasks : 10
Number of processes : 11
Total execution time: 50.611 [s]
Elapsed time: 5.073 [s]
Parallel Efficiency : 0.997654

Task list:
Command : Elapsed time
python3 hello.py < seed0.dat > output0.dat : 5.063 [s]
python3 hello.py < seed1.dat > output1.dat : 5.056 [s]
python3 hello.py < seed2.dat > output2.dat : 5.071 [s]
python3 hello.py < seed3.dat > output3.dat : 5.056 [s]
python3 hello.py < seed4.dat > output4.dat : 5.055 [s]
python3 hello.py < seed5.dat > output5.dat : 5.056 [s]
python3 hello.py < seed6.dat > output6.dat : 5.071 [s]
python3 hello.py < seed7.dat > output7.dat : 5.056 [s]
python3 hello.py < seed8.dat > output8.dat : 5.071 [s]
python3 hello.py < seed9.dat > output9.dat : 5.056 [s]
```

これは、10個のタスクを11プロセス(管理プロセスを除くト10プロセス)で実行し、ほぼ同時にすべてのジョブを実行できたため、並列化効率が100%近かった(99.8%)ことを示している。

## 使用上の注意

このリポジトリではCPSをGitのサブモジュールとして利用しているが、特にそうする必要はない。例えば別にビルドした`cps`の実行バイナリがあるなら、それをプロジェクトのディレクトリにコピーして、ジョブスクリプトを

```sh
#!/bin/sh

#SBATCH -p i8cpu
#SBATCH -N 1
#SBATCH -n 11

srun ./cps task.sh
```

としても良い。`task.sh`にはいくらでもジョブを並べて良いが、MPIプログラムを実行することはできない。また、スレッド並列をしている場合もおかしなことになるであろう。

## ライセンス

MIT
