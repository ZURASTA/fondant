defmodule Fondant.API.Filter.AllergenTest do
    use Fondant.Service.Case

    alias Fondant.API.Filter.Allergen

    setup do
        aa = Fondant.Service.Repo.insert!(%Fondant.Service.Locale.Model{ language: "aa" })
        zz = Fondant.Service.Repo.insert!(%Fondant.Service.Locale.Model{ language: "zz" })
        aa_bb = Fondant.Service.Repo.insert!(%Fondant.Service.Locale.Model{ language: "aa", country: "BB" })
        _zz_bb = Fondant.Service.Repo.insert!(%Fondant.Service.Locale.Model{ language: "zz", country: "BB" })

        Fondant.Service.Repo.insert!(%Fondant.Service.Filter.Type.Allergen.Translation.Name.Model{ translate_id: 1, locale_id: aa.id, term: "foo_aa" })
        Fondant.Service.Repo.insert!(%Fondant.Service.Filter.Type.Allergen.Translation.Name.Model{ translate_id: 1, locale_id: zz.id, term: "foo_zz" })
        Fondant.Service.Repo.insert!(%Fondant.Service.Filter.Type.Allergen.Translation.Name.Model{ translate_id: 1, locale_id: aa_bb.id, term: "foo_aa_bb" })
        Fondant.Service.Repo.insert!(%Fondant.Service.Filter.Type.Allergen.Translation.Name.Model{ translate_id: 2, locale_id: aa.id, term: "foobar_aa" })
        Fondant.Service.Repo.insert!(%Fondant.Service.Filter.Type.Allergen.Translation.Name.Model{ translate_id: 2, locale_id: zz.id, term: "foobar_zz" })
        Fondant.Service.Repo.insert!(%Fondant.Service.Filter.Type.Allergen.Translation.Name.Model{ translate_id: 2, locale_id: aa_bb.id, term: "foobar_aa_bb" })
        Fondant.Service.Repo.insert!(%Fondant.Service.Filter.Type.Allergen.Translation.Name.Model{ translate_id: 3, locale_id: aa.id, term: "bar_aa" })
        Fondant.Service.Repo.insert!(%Fondant.Service.Filter.Type.Allergen.Translation.Name.Model{ translate_id: 3, locale_id: zz.id, term: "bar_zz" })
        Fondant.Service.Repo.insert!(%Fondant.Service.Filter.Type.Allergen.Translation.Name.Model{ translate_id: 3, locale_id: aa_bb.id, term: "bar_aa_bb" })

        foo = Fondant.Service.Repo.insert!(%Fondant.Service.Filter.Type.Allergen.Model{ name: 1 })
        foobar = Fondant.Service.Repo.insert!(%Fondant.Service.Filter.Type.Allergen.Model{ name: 2 })
        bar = Fondant.Service.Repo.insert!(%Fondant.Service.Filter.Type.Allergen.Model{ name: 3 })

        {
            :ok,
            %{
                id: %{ foo: foo.id, foobar: foobar.id, bar: bar.id },
                data: %{
                    foo: %{
                        aa: %Fondant.Filter.Allergen{ id: foo.id, name: "foo_aa" },
                        zz: %Fondant.Filter.Allergen{ id: foo.id, name: "foo_zz" },
                        aa_bb: %Fondant.Filter.Allergen{ id: foo.id, name: "foo_aa_bb" }
                    },
                    foobar: %{
                        aa: %Fondant.Filter.Allergen{ id: foobar.id, name: "foobar_aa" },
                        zz: %Fondant.Filter.Allergen{ id: foobar.id, name: "foobar_zz" },
                        aa_bb: %Fondant.Filter.Allergen{ id: foobar.id, name: "foobar_aa_bb" }
                    },
                    bar: %{
                        aa: %Fondant.Filter.Allergen{ id: bar.id, name: "bar_aa" },
                        zz: %Fondant.Filter.Allergen{ id: bar.id, name: "bar_zz" },
                        aa_bb: %Fondant.Filter.Allergen{ id: bar.id, name: "bar_aa_bb" }
                    }
                }
            }
        }
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

        # test "non-existent locale" do
        #     assert_raise Fondant.Service.Locale.NotFoundError, fn -> Allergen.get(0, "bb") end
        # end

        test "non-existent translation" do
            assert { :error, "Allergen does not exist" } == Allergen.get(0, "zz_BB")
        end

        test "existing allergen", %{ id: %{ foo: foo_id, foobar: foobar_id, bar: bar_id }, data: allergen } do
            assert { :ok, allergen.foo.aa } == Allergen.get(foo_id, "aa")
            assert { :ok, allergen.foo.zz } == Allergen.get(foo_id, "zz")
            assert { :ok, allergen.foo.aa_bb } == Allergen.get(foo_id, "aa_BB")

            assert { :ok, allergen.foobar.aa } == Allergen.get(foobar_id, "aa")
            assert { :ok, allergen.foobar.zz } == Allergen.get(foobar_id, "zz")
            assert { :ok, allergen.foobar.aa_bb } == Allergen.get(foobar_id, "aa_BB")

            assert { :ok, allergen.bar.aa } == Allergen.get(bar_id, "aa")
            assert { :ok, allergen.bar.zz } == Allergen.get(bar_id, "zz")
            assert { :ok, allergen.bar.aa_bb } == Allergen.get(bar_id, "aa_BB")
        end
    end

    describe "find" do
        test "no queries", %{ id: %{ bar: bar_id }, data: allergen } do
            assert { :ok, { results, page } } = Allergen.find([], [locale: "aa", limit: 10])
            assert bar_id == page
            assert Enum.sort([
                allergen.foo.aa,
                allergen.foobar.aa,
                allergen.bar.aa
            ]) == Enum.sort(results)

            assert { :ok, { results, page } } = Allergen.find([], [locale: "zz", limit: 10])
            assert bar_id == page
            assert Enum.sort([
                allergen.foo.zz,
                allergen.foobar.zz,
                allergen.bar.zz
            ]) == Enum.sort(results)

            assert { :ok, { results, page } } = Allergen.find([], [locale: "aa_BB", limit: 10])
            assert bar_id == page
            assert Enum.sort([
                allergen.foo.aa,
                allergen.foo.aa_bb,
                allergen.foobar.aa,
                allergen.foobar.aa_bb,
                allergen.bar.aa,
                allergen.bar.aa_bb
            ]) == Enum.sort(results)
        end

        test "pagination", %{ id: %{ foo: foo_id, foobar: foobar_id, bar: bar_id }, data: allergen } do
            assert { :ok, { results, page } } = Allergen.find([], [locale: "aa", limit: 1])
            assert foo_id == page
            assert [
                allergen.foo.aa
            ] == results

            assert { :ok, { results, page } } = Allergen.find([], [locale: "aa", limit: 1, page: page])
            assert foobar_id == page
            assert [
                allergen.foobar.aa
            ] == results

            assert { :ok, { results, page } } = Allergen.find([], [locale: "aa", limit: 1, page: page])
            assert bar_id == page
            assert [
                allergen.bar.aa
            ] == results

            assert { :ok, { results, page } } = Allergen.find([], [locale: "aa", limit: 1, page: page])
            assert bar_id == page
            assert [] == results
        end

        test "query name", %{ id: %{ foo: foo_id, foobar: foobar_id }, data: allergen } do
            assert { :ok, { results, page } } = Allergen.find([name: "f"], [locale: "aa", limit: 10])
            assert foobar_id == page
            assert Enum.sort([
                allergen.foo.aa,
                allergen.foobar.aa
            ]) == Enum.sort(results)

            assert { :ok, { results, page } } = Allergen.find([name: "f"], [locale: "zz", limit: 10])
            assert foobar_id == page
            assert Enum.sort([
                allergen.foo.zz,
                allergen.foobar.zz
            ]) == Enum.sort(results)

            assert { :ok, { results, page } } = Allergen.find([name: "f"], [locale: "aa_BB", limit: 10])
            assert foobar_id == page
            assert Enum.sort([
                allergen.foo.aa,
                allergen.foo.aa_bb,
                allergen.foobar.aa,
                allergen.foobar.aa_bb
            ]) == Enum.sort(results)

            assert { :ok, { results, page } } = Allergen.find([name: "foo_a"], [locale: "aa", limit: 10])
            assert foo_id == page
            assert [
                allergen.foo.aa
            ] == results

            assert { :ok, { results, page } } = Allergen.find([name: "foo_a"], [locale: "zz", limit: 10])
            assert 0 == page
            assert [] == results

            assert { :ok, { results, page } } = Allergen.find([name: "foo_a"], [locale: "aa_BB", limit: 10])
            assert foo_id == page
            assert Enum.sort([
                allergen.foo.aa,
                allergen.foo.aa_bb
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

        test "query any", %{ id: %{ foo: foo_id, foobar: foobar_id }, data: allergen } do
            assert { :ok, { results, page } } = Allergen.find([any: "f"], [locale: "aa", limit: 10])
            assert foobar_id == page
            assert Enum.sort([
                allergen.foo.aa,
                allergen.foobar.aa
            ]) == Enum.sort(results)

            assert { :ok, { results, page } } = Allergen.find([any: "f"], [locale: "zz", limit: 10])
            assert foobar_id == page
            assert Enum.sort([
                allergen.foo.zz,
                allergen.foobar.zz
            ]) == Enum.sort(results)

            assert { :ok, { results, page } } = Allergen.find([any: "f"], [locale: "aa_BB", limit: 10])
            assert foobar_id == page
            assert Enum.sort([
                allergen.foo.aa,
                allergen.foo.aa_bb,
                allergen.foobar.aa,
                allergen.foobar.aa_bb
            ]) == Enum.sort(results)

            assert { :ok, { results, page } } = Allergen.find([any: "foo_a"], [locale: "aa", limit: 10])
            assert foo_id == page
            assert [
                allergen.foo.aa
            ] == results

            assert { :ok, { results, page } } = Allergen.find([any: "foo_a"], [locale: "zz", limit: 10])
            assert 0 == page
            assert [] == results

            assert { :ok, { results, page } } = Allergen.find([any: "foo_a"], [locale: "aa_BB", limit: 10])
            assert foo_id == page
            assert Enum.sort([
                allergen.foo.aa,
                allergen.foo.aa_bb
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

        test "all queries", %{ id: %{ foobar: foobar_id }, data: allergen } do
            assert { :ok, { results, page } } = Allergen.find([name: "f", any: "foob"], [locale: "aa", limit: 10])
            assert foobar_id == page
            assert [
                allergen.foobar.aa
            ] == results

            assert { :ok, { results, page } } = Allergen.find([name: "f", any: "bar"], [locale: "zz", limit: 10])
            assert 0 == page
            assert [] == results
        end
    end
end
