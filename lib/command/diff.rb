
require_relative "../diff"
    Target = Struct.new(:path, :oid, :mode, :data) do
      setup_pager

      if @args.first == "--cached"
        diff_head_index
      else
        diff_index_workspace
      end

      exit 0
    end

    private

    def diff_head_index
      @status.index_changes.each do |path, state|
        case state
        when :added    then print_diff(from_nothing(path), from_index(path))
        when :modified then print_diff(from_head(path), from_index(path))
        when :deleted  then print_diff(from_head(path), from_nothing(path))
        end
      end
    end

    def diff_index_workspace
    def from_head(path)
      entry = @status.head_tree.fetch(path)
      blob  = repo.database.load(entry.oid)

      Target.new(path, entry.oid, entry.mode.to_s(8), blob.data)
    end
      blob  = repo.database.load(entry.oid)

      Target.new(path, entry.oid, entry.mode.to_s(8), blob.data)
      Target.new(path, oid, mode.to_s(8), blob.data)
      Target.new(path, NULL_OID, nil, "")
    end

    def header(string)
      puts fmt(:bold, string)
      header("diff --git #{ a.path } #{ b.path }")
      if a.mode == nil
        header("new file mode #{ b.mode }")
      elsif b.mode == nil
        header("deleted file mode #{ a.mode }")
        header("old mode #{ a.mode }")
        header("new mode #{ b.mode }")
      header(oid_range)
      header("--- #{ a.diff_path }")
      header("+++ #{ b.diff_path }")

      hunks = ::Diff.diff_hunks(a.data, b.data)
      hunks.each { |hunk| print_diff_hunk(hunk) }
    end

    def print_diff_hunk(hunk)
      puts fmt(:cyan, hunk.header)
      hunk.edits.each { |edit| print_diff_edit(edit) }
    end

    def print_diff_edit(edit)
      text = edit.to_s.rstrip

      case edit.type
      when :eql then puts text
      when :ins then puts fmt(:green, text)
      when :del then puts fmt(:red, text)
      end