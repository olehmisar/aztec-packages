import type { CircuitName } from '@aztec/circuit-types/stats';
import { type ClientProtocolArtifact, type ServerProtocolArtifact } from '@aztec/noir-protocol-circuits-types';

export function mapProtocolArtifactNameToCircuitName(
  artifact: ServerProtocolArtifact | ClientProtocolArtifact,
): CircuitName {
  switch (artifact) {
    case 'BaseParityArtifact':
      return 'base-parity';
    case 'RootParityArtifact':
      return 'root-parity';
    case 'BaseRollupArtifact':
      return 'base-rollup';
    case 'MergeRollupArtifact':
      return 'merge-rollup';
    case 'BlockRootRollupArtifact':
      return 'block-root-rollup';
    case 'EmptyBlockRootRollupArtifact':
      return 'empty-block-root-rollup';
    case 'BlockMergeRollupArtifact':
      return 'block-merge-rollup';
    case 'RootRollupArtifact':
      return 'root-rollup';
    case 'PublicKernelInnerArtifact':
      return 'public-kernel-inner';
    case 'PublicKernelMergeArtifact':
      return 'public-kernel-merge';
    case 'PublicKernelTailArtifact':
      return 'public-kernel-tail';
    case 'PrivateKernelInitArtifact':
      return 'private-kernel-init';
    case 'PrivateKernelInnerArtifact':
      return 'private-kernel-inner';
    case 'PrivateKernelTailArtifact':
      return 'private-kernel-tail';
    case 'PrivateKernelTailToPublicArtifact':
      return 'private-kernel-tail-to-public';
    case 'EmptyNestedArtifact':
      return 'empty-nested';
    case 'PrivateKernelEmptyArtifact':
      return 'private-kernel-empty';
    default: {
      if (artifact.startsWith('PrivateKernelReset')) {
        return 'private-kernel-reset';
      }
      throw new Error(`Unknown circuit type: ${artifact}`);
    }
  }
}
