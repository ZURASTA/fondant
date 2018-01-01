defmodule Fondant.API.Filter.DietTest do
    use Fondant.Service.Case

    alias Fondant.API.Filter.Diet

    setup do
        aa = Fondant.Service.Repo.insert!(%Fondant.Service.Locale.Model{ language: "aa" })
        zz = Fondant.Service.Repo.insert!(%Fondant.Service.Locale.Model{ language: "zz" })
        aa_bb = Fondant.Service.Repo.insert!(%Fondant.Service.Locale.Model{ language: "aa", country: "BB" })
        _zz_bb = Fondant.Service.Repo.insert!(%Fondant.Service.Locale.Model{ language: "zz", country: "BB" })

        Fondant.Service.Repo.insert!(%Fondant.Service.Filter.Type.Diet.Translation.Name.Model{ translate_id: 1, locale_id: aa.id, term: "foo_aa" })
        Fondant.Service.Repo.insert!(%Fondant.Service.Filter.Type.Diet.Translation.Name.Model{ translate_id: 1, locale_id: zz.id, term: "foo_zz" })
        Fondant.Service.Repo.insert!(%Fondant.Service.Filter.Type.Diet.Translation.Name.Model{ translate_id: 1, locale_id: aa_bb.id, term: "foo_aa_bb" })
        Fondant.Service.Repo.insert!(%Fondant.Service.Filter.Type.Diet.Translation.Name.Model{ translate_id: 2, locale_id: aa.id, term: "foobar_aa" })
        Fondant.Service.Repo.insert!(%Fondant.Service.Filter.Type.Diet.Translation.Name.Model{ translate_id: 2, locale_id: zz.id, term: "foobar_zz" })
        Fondant.Service.Repo.insert!(%Fondant.Service.Filter.Type.Diet.Translation.Name.Model{ translate_id: 2, locale_id: aa_bb.id, term: "foobar_aa_bb" })
        Fondant.Service.Repo.insert!(%Fondant.Service.Filter.Type.Diet.Translation.Name.Model{ translate_id: 3, locale_id: aa.id, term: "bar_aa" })
        Fondant.Service.Repo.insert!(%Fondant.Service.Filter.Type.Diet.Translation.Name.Model{ translate_id: 3, locale_id: zz.id, term: "bar_zz" })
        Fondant.Service.Repo.insert!(%Fondant.Service.Filter.Type.Diet.Translation.Name.Model{ translate_id: 3, locale_id: aa_bb.id, term: "bar_aa_bb" })

        foo = Fondant.Service.Repo.insert!(%Fondant.Service.Filter.Type.Diet.Model{ ref: "foo", ref_id: Ecto.UUID.generate(), name: 1 })
        foobar = Fondant.Service.Repo.insert!(%Fondant.Service.Filter.Type.Diet.Model{ ref: "foobar", ref_id: Ecto.UUID.generate(), name: 2 })
        bar = Fondant.Service.Repo.insert!(%Fondant.Service.Filter.Type.Diet.Model{ ref: "bar", ref_id: Ecto.UUID.generate(), name: 3 })

        {
            :ok,
            %{
                id: %{ foo: foo.id, foobar: foobar.id, bar: bar.id },
                data: %{
                    foo: %{
                        aa: %Fondant.Filter.Diet{ id: foo.id, name: "foo_aa" },
                        zz: %Fondant.Filter.Diet{ id: foo.id, name: "foo_zz" },
                        aa_bb: %Fondant.Filter.Diet{ id: foo.id, name: "foo_aa_bb" }
                    },
                    foobar: %{
                        aa: %Fondant.Filter.Diet{ id: foobar.id, name: "foobar_aa" },
                        zz: %Fondant.Filter.Diet{ id: foobar.id, name: "foobar_zz" },
                        aa_bb: %Fondant.Filter.Diet{ id: foobar.id, name: "foobar_aa_bb" }
                    },
                    bar: %{
                        aa: %Fondant.Filter.Diet{ id: bar.id, name: "bar_aa" },
                        zz: %Fondant.Filter.Diet{ id: bar.id, name: "bar_zz" },
                        aa_bb: %Fondant.Filter.Diet{ id: bar.id, name: "bar_aa_bb" }
                    }
                }
            }
        }
    end

    test "retrieve queryables" do
        assert Enum.sort([:any, :name]) == Enum.sort(Diet.queryables())
    end

    describe "get" do
        test "non-existent diet" do
            assert { :error, "Diet does not exist" } == Diet.get(0, "aa")
            assert { :error, "Diet does not exist" } == Diet.get(0, "zz")
            assert { :error, "Diet does not exist" } == Diet.get(0, "aa_BB")
        end

        test "non-existent locale" do
            assert { :error, "Invalid locale" } == Diet.get(0, "bb")
        end

        test "non-existent translation" do
            assert { :error, "Diet does not exist" } == Diet.get(0, "zz_BB")
        end

        test "existing diet", %{ id: %{ foo: foo_id, foobar: foobar_id, bar: bar_id }, data: diet } do
            assert { :ok, diet.foo.aa } == Diet.get(foo_id, "aa")
            assert { :ok, diet.foo.zz } == Diet.get(foo_id, "zz")
            assert { :ok, diet.foo.aa_bb } == Diet.get(foo_id, "aa_BB")

            assert { :ok, diet.foobar.aa } == Diet.get(foobar_id, "aa")
            assert { :ok, diet.foobar.zz } == Diet.get(foobar_id, "zz")
            assert { :ok, diet.foobar.aa_bb } == Diet.get(foobar_id, "aa_BB")

            assert { :ok, diet.bar.aa } == Diet.get(bar_id, "aa")
            assert { :ok, diet.bar.zz } == Diet.get(bar_id, "zz")
            assert { :ok, diet.bar.aa_bb } == Diet.get(bar_id, "aa_BB")
        end
    end

    describe "find" do
        test "non-existent locale" do
            assert { :error, "No locale provided" } == Diet.find([], [])
            assert { :error, "Invalid locale" } == Diet.find([], [locale: "bb"])
        end

        test "no queries", %{ id: %{ bar: bar_id }, data: diet } do
            assert { :ok, { results, page } } = Diet.find([], [locale: "aa", limit: 10])
            assert bar_id == page
            assert Enum.sort([
                diet.foo.aa,
                diet.foobar.aa,
                diet.bar.aa
            ]) == Enum.sort(results)

            assert { :ok, { results, page } } = Diet.find([], [locale: "zz", limit: 10])
            assert bar_id == page
            assert Enum.sort([
                diet.foo.zz,
                diet.foobar.zz,
                diet.bar.zz
            ]) == Enum.sort(results)

            assert { :ok, { results, page } } = Diet.find([], [locale: "aa_BB", limit: 10])
            assert bar_id == page
            assert Enum.sort([
                diet.foo.aa,
                diet.foo.aa_bb,
                diet.foobar.aa,
                diet.foobar.aa_bb,
                diet.bar.aa,
                diet.bar.aa_bb
            ]) == Enum.sort(results)
        end

        test "pagination", %{ id: %{ foo: foo_id, foobar: foobar_id, bar: bar_id }, data: diet } do
            assert { :ok, { results, page } } = Diet.find([], [locale: "aa", limit: 1])
            assert foo_id == page
            assert [
                diet.foo.aa
            ] == results

            assert { :ok, { results, page } } = Diet.find([], [locale: "aa", limit: 1, page: page])
            assert foobar_id == page
            assert [
                diet.foobar.aa
            ] == results

            assert { :ok, { results, page } } = Diet.find([], [locale: "aa", limit: 1, page: page])
            assert bar_id == page
            assert [
                diet.bar.aa
            ] == results

            assert { :ok, { results, page } } = Diet.find([], [locale: "aa", limit: 1, page: page])
            assert bar_id == page
            assert [] == results
        end

        test "query name", %{ id: %{ foo: foo_id, foobar: foobar_id }, data: diet } do
            assert { :ok, { results, page } } = Diet.find([name: "f"], [locale: "aa", limit: 10])
            assert foobar_id == page
            assert Enum.sort([
                diet.foo.aa,
                diet.foobar.aa
            ]) == Enum.sort(results)

            assert { :ok, { results, page } } = Diet.find([name: "f"], [locale: "zz", limit: 10])
            assert foobar_id == page
            assert Enum.sort([
                diet.foo.zz,
                diet.foobar.zz
            ]) == Enum.sort(results)

            assert { :ok, { results, page } } = Diet.find([name: "f"], [locale: "aa_BB", limit: 10])
            assert foobar_id == page
            assert Enum.sort([
                diet.foo.aa,
                diet.foo.aa_bb,
                diet.foobar.aa,
                diet.foobar.aa_bb
            ]) == Enum.sort(results)

            assert { :ok, { results, page } } = Diet.find([name: "foo_a"], [locale: "aa", limit: 10])
            assert foo_id == page
            assert [
                diet.foo.aa
            ] == results

            assert { :ok, { results, page } } = Diet.find([name: "foo_a"], [locale: "zz", limit: 10])
            assert 0 == page
            assert [] == results

            assert { :ok, { results, page } } = Diet.find([name: "foo_a"], [locale: "aa_BB", limit: 10])
            assert foo_id == page
            assert Enum.sort([
                diet.foo.aa,
                diet.foo.aa_bb
            ]) == Enum.sort(results)

            assert { :ok, { results, page } } = Diet.find([name: "barfoo"], [locale: "aa", limit: 10])
            assert 0 == page
            assert [] == results

            assert { :ok, { results, page } } = Diet.find([name: "barfoo"], [locale: "zz", limit: 10])
            assert 0 == page
            assert [] == results

            assert { :ok, { results, page } } = Diet.find([name: "barfoo"], [locale: "aa_BB", limit: 10])
            assert 0 == page
            assert [] == results

            assert { :ok, { results, page } } = Diet.find([name: "f", name: "b"], [locale: "aa", limit: 10])
            assert 0 == page
            assert [] == results

            assert { :ok, { results, page } } = Diet.find([name: "f", name: "b"], [locale: "zz", limit: 10])
            assert 0 == page
            assert [] == results

            assert { :ok, { results, page } } = Diet.find([name: "f", name: "b"], [locale: "aa_BB", limit: 10])
            assert 0 == page
            assert [] == results
        end

        test "query any", %{ id: %{ foo: foo_id, foobar: foobar_id }, data: diet } do
            assert { :ok, { results, page } } = Diet.find([any: "f"], [locale: "aa", limit: 10])
            assert foobar_id == page
            assert Enum.sort([
                diet.foo.aa,
                diet.foobar.aa
            ]) == Enum.sort(results)

            assert { :ok, { results, page } } = Diet.find([any: "f"], [locale: "zz", limit: 10])
            assert foobar_id == page
            assert Enum.sort([
                diet.foo.zz,
                diet.foobar.zz
            ]) == Enum.sort(results)

            assert { :ok, { results, page } } = Diet.find([any: "f"], [locale: "aa_BB", limit: 10])
            assert foobar_id == page
            assert Enum.sort([
                diet.foo.aa,
                diet.foo.aa_bb,
                diet.foobar.aa,
                diet.foobar.aa_bb
            ]) == Enum.sort(results)

            assert { :ok, { results, page } } = Diet.find([any: "foo_a"], [locale: "aa", limit: 10])
            assert foo_id == page
            assert [
                diet.foo.aa
            ] == results

            assert { :ok, { results, page } } = Diet.find([any: "foo_a"], [locale: "zz", limit: 10])
            assert 0 == page
            assert [] == results

            assert { :ok, { results, page } } = Diet.find([any: "foo_a"], [locale: "aa_BB", limit: 10])
            assert foo_id == page
            assert Enum.sort([
                diet.foo.aa,
                diet.foo.aa_bb
            ]) == Enum.sort(results)

            assert { :ok, { results, page } } = Diet.find([any: "barfoo"], [locale: "aa", limit: 10])
            assert 0 == page
            assert [] == results

            assert { :ok, { results, page } } = Diet.find([any: "barfoo"], [locale: "zz", limit: 10])
            assert 0 == page
            assert [] == results

            assert { :ok, { results, page } } = Diet.find([any: "barfoo"], [locale: "aa_BB", limit: 10])
            assert 0 == page
            assert [] == results

            assert { :ok, { results, page } } = Diet.find([any: "f", any: "b"], [locale: "aa", limit: 10])
            assert 0 == page
            assert [] == results

            assert { :ok, { results, page } } = Diet.find([any: "f", any: "b"], [locale: "zz", limit: 10])
            assert 0 == page
            assert [] == results

            assert { :ok, { results, page } } = Diet.find([any: "f", any: "b"], [locale: "aa_BB", limit: 10])
            assert 0 == page
            assert [] == results
        end

        test "all queries", %{ id: %{ foobar: foobar_id }, data: diet } do
            assert { :ok, { results, page } } = Diet.find([name: "f", any: "foob"], [locale: "aa", limit: 10])
            assert foobar_id == page
            assert [
                diet.foobar.aa
            ] == results

            assert { :ok, { results, page } } = Diet.find([name: "f", any: "bar"], [locale: "zz", limit: 10])
            assert 0 == page
            assert [] == results
        end
    end
end
