require 'spec_helper'
require 'grape_entity'

describe GrapeEntityMatchers::DocumentMatcher do
  let(:documentation) do
    {
      type: String,
      types: [String, Integer],
      desc: 'Some string',
      default: 'xyz',
      required: false,
      values: ['abc', 'xyz']
    }
  end
  before(:all) do
    class TestEntity < Grape::Entity
      expose :str, documentation: {
        type: String,
        types: [String, Integer],
        desc: 'Some string',
        default: 'xyz',
        required: false,
        values: ['abc', 'xyz']
      }
      expose :no_doc
    end
  end

  subject(:entity) { TestEntity }

  context "ensure that the exposure matches the documentation" do
    it { is_expected.to document(:str).with(documentation) }
  end

  context "ensure individual keys of documentation" do
    it { is_expected.to document(:str).type(String) }
    it { is_expected.not_to document(:str).type(Fixnum) }

    it { is_expected.to document(:str).types([String, Integer])}
    it { is_expected.not_to document(:str).types([String, Integer, Fixnum]) }

    it { is_expected.to document(:str).desc('Some string') }
    it { is_expected.not_to document(:str).desc('Some other string') }

    it { is_expected.to document(:str).default('xyz') }
    it { is_expected.not_to document(:str).default('abc') }

    it { is_expected.to document(:str).required(false) }
    it { is_expected.not_to document(:str).required(true) }

    it { is_expected.to document(:str).values(['abc', 'xyz']) }
    it { is_expected.not_to document(:str).values(['foo', 'bar']) }
  end

  context "ensure a combination of keys of documentation" do
    it { is_expected.to document(:str).type(String).desc('Some string') }
  end

  context "ensure that an exposure is not documented" do
    it { is_expected.to_not document(:no_doc) }
  end

  context "ensure that a specific documentation is not used" do
    it { is_expected.to_not document(:str).with(type: String, required: false) }
  end
end
