      jit_cmd "branch", "topic", "@^^"


    it "prints a log starting from a specified commit" do
      jit_cmd "log", "--pretty=oneline", "@^"

      assert_stdout <<~LOGS
        #{ @commits[1].oid } B
        #{ @commits[2].oid } A
      LOGS
    end

    it "prints a log with short decorations" do
      jit_cmd "log", "--pretty=oneline", "--decorate=short"

      assert_stdout <<~LOGS
        #{ @commits[0].oid } (HEAD -> master) C
        #{ @commits[1].oid } B
        #{ @commits[2].oid } (topic) A
      LOGS
    end

    it "prints a log with detached HEAD" do
      jit_cmd "checkout", "@"
      jit_cmd "log", "--pretty=oneline", "--decorate=short"

      assert_stdout <<~LOGS
        #{ @commits[0].oid } (HEAD, master) C
        #{ @commits[1].oid } B
        #{ @commits[2].oid } (topic) A
      LOGS
    end

    it "prints a log with full decorations" do
      jit_cmd "log", "--pretty=oneline", "--decorate=full"

      assert_stdout <<~LOGS
        #{ @commits[0].oid } (HEAD -> refs/heads/master) C
        #{ @commits[1].oid } B
        #{ @commits[2].oid } (refs/heads/topic) A
      LOGS
    end

    it "prints a log with patches" do
      jit_cmd "log", "--pretty=oneline", "--patch"

      assert_stdout <<~LOGS
        #{ @commits[0].oid } C
        diff --git a/file.txt b/file.txt
        index 7371f47..96d80cd 100644
        --- a/file.txt
        +++ b/file.txt
        @@ -1,1 +1,1 @@
        -B
        +C
        #{ @commits[1].oid } B
        diff --git a/file.txt b/file.txt
        index 8c7e5a6..7371f47 100644
        --- a/file.txt
        +++ b/file.txt
        @@ -1,1 +1,1 @@
        -A
        +B
        #{ @commits[2].oid } A
        diff --git a/file.txt b/file.txt
        new file mode 100644
        index 0000000..8c7e5a6
        --- /dev/null
        +++ b/file.txt
        @@ -0,0 +1,1 @@
        +A
      LOGS
    end