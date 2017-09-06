defmodule Fondant.Service.Filter.Type.AllergenTest do
    use Fondant.Service.Case

    alias Fondant.Service.Filter.Type.Allergen

    setup do
        aa = Fondant.Service.Repo.insert!(%Fondant.Service.Locale.Model{ language: "aa" })
        zz = Fondant.Service.Repo.insert!(%Fondant.Service.Locale.Model{ language: "zz" })
        aa_bb = Fondant.Service.Repo.insert!(%Fondant.Service.Locale.Model{ language: "aa", country: "BB" })
        _zz_bb = Fondant.Service.Repo.insert!(%Fondant.Service.Locale.Model{ language: "zz", country: "BB" })

        Fondant.Service.Repo.insert!(%Allergen.Translation.Name.Model{ translate_id: 1, locale_id: aa.id, term: "foo_aa" })
        Fondant.Service.Repo.insert!(%Allergen.Translation.Name.Model{ translate_id: 1, locale_id: zz.id, term: "foo_zz" })
        Fondant.Service.Repo.insert!(%Allergen.Translation.Name.Model{ translate_id: 1, locale_id: aa_bb.id, term: "foo_aa_bb" })
        Fondant.Service.Repo.insert!(%Allergen.Translation.Name.Model{ translate_id: 2, locale_id: aa.id, term: "foobar_aa" })
        Fondant.Service.Repo.insert!(%Allergen.Translation.Name.Model{ translate_id: 2, locale_id: zz.id, term: "foobar_zz" })
        Fondant.Service.Repo.insert!(%Allergen.Translation.Name.Model{ translate_id: 2, locale_id: aa_bb.id, term: "foobar_aa_bb" })
        Fondant.Service.Repo.insert!(%Allergen.Translation.Name.Model{ translate_id: 3, locale_id: aa.id, term: "bar_aa" })
        Fondant.Service.Repo.insert!(%Allergen.Translation.Name.Model{ translate_id: 3, locale_id: zz.id, term: "bar_zz" })
        Fondant.Service.Repo.insert!(%Allergen.Translation.Name.Model{ translate_id: 3, locale_id: aa_bb.id, term: "bar_aa_bb" })

        foo = Fondant.Service.Repo.insert!(%Allergen.Model{ name: 1 })
        foobar = Fondant.Service.Repo.insert!(%Allergen.Model{ name: 2 })
        bar = Fondant.Service.Repo.insert!(%Allergen.Model{ name: 3 })

        { :ok, %{ foo: foo, foobar: foobar, bar: bar } }
    end

    test "retrieve queryables" do
        assert Enum.sort([:any, :name]) == Enum.sort(Allergen.queryables())
    end

    describe "get" do
        test "non-existent allergen" do
            assert { :error, "Allergen does not exist" } == Allergen.get(0, "aa")
            assert { :error, "Allergen does not exist" } == Allergen.get(0, "zz")
            assert { :error, "Allergen does not exist" } == Allergen.get(0, "aa_BB")
        end

        test "non-existent locale" do
            assert_raise Fondant.Service.Locale.NotFoundError, fn -> Allergen.get(0, "bb") end
        end

        test "non-existent translation" do
            assert { :error, "Allergen does not exist" } == Allergen.get(0, "zz_BB")
        end

        test "existing allergen", %{ foo: foo, foobar: foobar, bar: bar } do
            assert { :ok, %Fondant.Filter.Allergen{ id: foo.id, name: "foo_aa" } } == Allergen.get(foo.id, "aa")
            assert { :ok, %Fondant.Filter.Allergen{ id: foo.id, name: "foo_zz" } } == Allergen.get(foo.id, "zz")
            assert { :ok, %Fondant.Filter.Allergen{ id: foo.id, name: "foo_aa_bb" } } == Allergen.get(foo.id, "aa_BB")

            assert { :ok, %Fondant.Filter.Allergen{ id: foobar.id, name: "foobar_aa" } } == Allergen.get(foobar.id, "aa")
            assert { :ok, %Fondant.Filter.Allergen{ id: foobar.id, name: "foobar_zz" } } == Allergen.get(foobar.id, "zz")
            assert { :ok, %Fondant.Filter.Allergen{ id: foobar.id, name: "foobar_aa_bb" } } == Allergen.get(foobar.id, "aa_BB")

            assert { :ok, %Fondant.Filter.Allergen{ id: bar.id, name: "bar_aa" } } == Allergen.get(bar.id, "aa")
            assert { :ok, %Fondant.Filter.Allergen{ id: bar.id, name: "bar_zz" } } == Allergen.get(bar.id, "zz")
            assert { :ok, %Fondant.Filter.Allergen{ id: bar.id, name: "bar_aa_bb" } } == Allergen.get(bar.id, "aa_BB")
        end
    end

    describe "find" do
        test "no queries", %{ foo: foo, foobar: foobar, bar: bar } do
            assert { :ok, { results, page } } = Allergen.find([], [locale: "aa", limit: 10])
            assert bar.id == page
            assert Enum.sort([
                %Fondant.Filter.Allergen{ id: foo.id, name: "foo_aa" },
                %Fondant.Filter.Allergen{ id: foobar.id, name: "foobar_aa" },
                %Fondant.Filter.Allergen{ id: bar.id, name: "bar_aa" }
            ]) == Enum.sort(results)

            assert { :ok, { results, page } } = Allergen.find([], [locale: "zz", limit: 10])
            assert bar.id == page
            assert Enum.sort([
                %Fondant.Filter.Allergen{ id: foo.id, name: "foo_zz" },
                %Fondant.Filter.Allergen{ id: foobar.id, name: "foobar_zz" },
                %Fondant.Filter.Allergen{ id: bar.id, name: "bar_zz" }
            ]) == Enum.sort(results)

            assert { :ok, { results, page } } = Allergen.find([], [locale: "aa_BB", limit: 10])
            assert bar.id == page
            assert Enum.sort([
                %Fondant.Filter.Allergen{ id: foo.id, name: "foo_aa" },
                %Fondant.Filter.Allergen{ id: foo.id, name: "foo_aa_bb" },
                %Fondant.Filter.Allergen{ id: foobar.id, name: "foobar_aa" },
                %Fondant.Filter.Allergen{ id: foobar.id, name: "foobar_aa_bb" },
                %Fondant.Filter.Allergen{ id: bar.id, name: "bar_aa" },
                %Fondant.Filter.Allergen{ id: bar.id, name: "bar_aa_bb" }
            ]) == Enum.sort(results)
        end

        test "pagination", %{ foo: foo, foobar: foobar, bar: bar } do
            assert { :ok, { results, page } } = Allergen.find([], [locale: "aa", limit: 1])
            assert foo.id == page
            assert [
                %Fondant.Filter.Allergen{ id: foo.id, name: "foo_aa" }
            ] == results

            assert { :ok, { results, page } } = Allergen.find([], [locale: "aa", limit: 1, page: page])
            assert foobar.id == page
            assert [
                %Fondant.Filter.Allergen{ id: foobar.id, name: "foobar_aa" }
            ] == results

            assert { :ok, { results, page } } = Allergen.find([], [locale: "aa", limit: 1, page: page])
            assert bar.id == page
            assert [
                %Fondant.Filter.Allergen{ id: bar.id, name: "bar_aa" }
            ] == results

            assert { :ok, { results, page } } = Allergen.find([], [locale: "aa", limit: 1, page: page])
            assert bar.id == page
            assert [] == results
        end

        test "query name", %{ foo: foo, foobar: foobar } do
            assert { :ok, { results, page } } = Allergen.find([name: "f"], [locale: "aa", limit: 10])
            assert foobar.id == page
            assert Enum.sort([
                %Fondant.Filter.Allergen{ id: foo.id, name: "foo_aa" },
                %Fondant.Filter.Allergen{ id: foobar.id, name: "foobar_aa" },
            ]) == Enum.sort(results)

            assert { :ok, { results, page } } = Allergen.find([name: "f"], [locale: "zz", limit: 10])
            assert foobar.id == page
            assert Enum.sort([
                %Fondant.Filter.Allergen{ id: foo.id, name: "foo_zz" },
                %Fondant.Filter.Allergen{ id: foobar.id, name: "foobar_zz" },
            ]) == Enum.sort(results)

            assert { :ok, { results, page } } = Allergen.find([name: "f"], [locale: "aa_BB", limit: 10])
            assert foobar.id == page
            assert Enum.sort([
                %Fondant.Filter.Allergen{ id: foo.id, name: "foo_aa" },
                %Fondant.Filter.Allergen{ id: foo.id, name: "foo_aa_bb" },
                %Fondant.Filter.Allergen{ id: foobar.id, name: "foobar_aa" },
                %Fondant.Filter.Allergen{ id: foobar.id, name: "foobar_aa_bb" },
            ]) == Enum.sort(results)

            assert { :ok, { results, page } } = Allergen.find([name: "foo_a"], [locale: "aa", limit: 10])
            assert foo.id == page
            assert [
                %Fondant.Filter.Allergen{ id: foo.id, name: "foo_aa" }
            ] == results

            assert { :ok, { results, page } } = Allergen.find([name: "foo_a"], [locale: "zz", limit: 10])
            assert 0 == page
            assert [] == results

            assert { :ok, { results, page } } = Allergen.find([name: "foo_a"], [locale: "aa_BB", limit: 10])
            assert foo.id == page
            assert Enum.sort([
                %Fondant.Filter.Allergen{ id: foo.id, name: "foo_aa" },
                %Fondant.Filter.Allergen{ id: foo.id, name: "foo_aa_bb" }
            ]) == Enum.sort(results)

            assert { :ok, { results, page } } = Allergen.find([name: "barfoo"], [locale: "aa", limit: 10])
            assert 0 == page
            assert [] == results

            assert { :ok, { results, page } } = Allergen.find([name: "barfoo"], [locale: "zz", limit: 10])
            assert 0 == page
            assert [] == results

            assert { :ok, { results, page } } = Allergen.find([name: "barfoo"], [locale: "aa_BB", limit: 10])
            assert 0 == page
            assert [] == results

            assert { :ok, { results, page } } = Allergen.find([name: "f", name: "b"], [locale: "aa", limit: 10])
            assert 0 == page
            assert [] == results

            assert { :ok, { results, page } } = Allergen.find([name: "f", name: "b"], [locale: "zz", limit: 10])
            assert 0 == page
            assert [] == results

            assert { :ok, { results, page } } = Allergen.find([name: "f", name: "b"], [locale: "aa_BB", limit: 10])
            assert 0 == page
            assert [] == results
        end

        test "query any", %{ foo: foo, foobar: foobar } do
            assert { :ok, { results, page } } = Allergen.find([any: "f"], [locale: "aa", limit: 10])
            assert foobar.id == page
            assert Enum.sort([
                %Fondant.Filter.Allergen{ id: foo.id, name: "foo_aa" },
                %Fondant.Filter.Allergen{ id: foobar.id, name: "foobar_aa" },
            ]) == Enum.sort(results)

            assert { :ok, { results, page } } = Allergen.find([any: "f"], [locale: "zz", limit: 10])
            assert foobar.id == page
            assert Enum.sort([
                %Fondant.Filter.Allergen{ id: foo.id, name: "foo_zz" },
                %Fondant.Filter.Allergen{ id: foobar.id, name: "foobar_zz" },
            ]) == Enum.sort(results)

            assert { :ok, { results, page } } = Allergen.find([any: "f"], [locale: "aa_BB", limit: 10])
            assert foobar.id == page
            assert Enum.sort([
                %Fondant.Filter.Allergen{ id: foo.id, name: "foo_aa" },
                %Fondant.Filter.Allergen{ id: foo.id, name: "foo_aa_bb" },
                %Fondant.Filter.Allergen{ id: foobar.id, name: "foobar_aa" },
                %Fondant.Filter.Allergen{ id: foobar.id, name: "foobar_aa_bb" },
            ]) == Enum.sort(results)

            assert { :ok, { results, page } } = Allergen.find([any: "foo_a"], [locale: "aa", limit: 10])
            assert foo.id == page
            assert [
                %Fondant.Filter.Allergen{ id: foo.id, name: "foo_aa" }
            ] == results

            assert { :ok, { results, page } } = Allergen.find([any: "foo_a"], [locale: "zz", limit: 10])
            assert 0 == page
            assert [] == results

            assert { :ok, { results, page } } = Allergen.find([any: "foo_a"], [locale: "aa_BB", limit: 10])
            assert foo.id == page
            assert Enum.sort([
                %Fondant.Filter.Allergen{ id: foo.id, name: "foo_aa" },
                %Fondant.Filter.Allergen{ id: foo.id, name: "foo_aa_bb" }
            ]) == Enum.sort(results)

            assert { :ok, { results, page } } = Allergen.find([any: "barfoo"], [locale: "aa", limit: 10])
            assert 0 == page
            assert [] == results

            assert { :ok, { results, page } } = Allergen.find([any: "barfoo"], [locale: "zz", limit: 10])
            assert 0 == page
            assert [] == results

            assert { :ok, { results, page } } = Allergen.find([any: "barfoo"], [locale: "aa_BB", limit: 10])
            assert 0 == page
            assert [] == results

            assert { :ok, { results, page } } = Allergen.find([any: "f", any: "b"], [locale: "aa", limit: 10])
            assert 0 == page
            assert [] == results

            assert { :ok, { results, page } } = Allergen.find([any: "f", any: "b"], [locale: "zz", limit: 10])
            assert 0 == page
            assert [] == results

            assert { :ok, { results, page } } = Allergen.find([any: "f", any: "b"], [locale: "aa_BB", limit: 10])
            assert 0 == page
            assert [] == results
        end

        test "all queries", %{ foobar: foobar } do
            assert { :ok, { results, page } } = Allergen.find([name: "f", any: "foob"], [locale: "aa", limit: 10])
            assert foobar.id == page
            assert [
                %Fondant.Filter.Allergen{ id: foobar.id, name: "foobar_aa" },
            ] == results

            assert { :ok, { results, page } } = Allergen.find([name: "f", any: "bar"], [locale: "zz", limit: 10])
            assert 0 == page
            assert [] == results
        end
    end
end
